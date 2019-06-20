import 'dart:convert';
import 'dart:typed_data';

Uint32List stringToUTF8Bytes(String s) {
  Uint32List arr = new Uint32List(s.length * 4);
  int arri = 0;

  for (int i = 0; i < s.length; i++) {
    int c = s.codeUnitAt(i);
    if (c < 0x80) {
      arr[arri++] = (c);
    } else if (c < 0x800) {
      arr[arri++] = (0xc0 | c >> 6);
      arr[arri++] = (0x80 | c & 0x3f);
    } else if (c < 0xd800) {
      arr[arri++] = (0xe0 | c >> 12);
      arr[arri++] = (0x80 | (c >> 6) & 0x3f);
      arr[arri++] = (0x80 | c & 0x3f);
    } else {
      if (i >= s.length - 1) {
        //  "invalid string"
        throw new Error();
      }
      i++; // get one more character
      c = (c & 0x3ff) << 10;
      c |= s.codeUnitAt(i) & 0x3ff;
      c += 0x10000;

      arr[arri++] = (0xf0 | c >> 18);
      arr[arri++] = (0x80 | (c >> 12) & 0x3f);
      arr[arri++] = (0x80 | (c >> 6) & 0x3f);
      arr[arri++] = (0x80 | c & 0x3f);
    }
  }
  return arr.sublist(0, arri);
}

String bytesToHex(Uint32List p) {
  /** @const */
  List<String> enc = '0123456789abcdef'.split('');

  int len = p.length, i = 0;
  List<String> arr = [];

  for (; i < len; i++) {
    arr.add(enc[((p[i] & 0xFFFFFFFF) >> 4) & 15]);
    arr.add(enc[((p[i] & 0xFFFFFFFF) >> 0) & 15]);
  }
  return arr.join('');
}

Uint32List scrypt(
    String password, String salt, int N, int r, int p, int dkLen) {
  Uint32List SHA256(Uint32List m) {
    const K = [
      0x428a2f98,
      0x71374491,
      0xb5c0fbcf,
      0xe9b5dba5,
      0x3956c25b,
      0x59f111f1,
      0x923f82a4,
      0xab1c5ed5,
      0xd807aa98,
      0x12835b01,
      0x243185be,
      0x550c7dc3,
      0x72be5d74,
      0x80deb1fe,
      0x9bdc06a7,
      0xc19bf174,
      0xe49b69c1,
      0xefbe4786,
      0x0fc19dc6,
      0x240ca1cc,
      0x2de92c6f,
      0x4a7484aa,
      0x5cb0a9dc,
      0x76f988da,
      0x983e5152,
      0xa831c66d,
      0xb00327c8,
      0xbf597fc7,
      0xc6e00bf3,
      0xd5a79147,
      0x06ca6351,
      0x14292967,
      0x27b70a85,
      0x2e1b2138,
      0x4d2c6dfc,
      0x53380d13,
      0x650a7354,
      0x766a0abb,
      0x81c2c92e,
      0x92722c85,
      0xa2bfe8a1,
      0xa81a664b,
      0xc24b8b70,
      0xc76c51a3,
      0xd192e819,
      0xd6990624,
      0xf40e3585,
      0x106aa070,
      0x19a4c116,
      0x1e376c08,
      0x2748774c,
      0x34b0bcb5,
      0x391c0cb3,
      0x4ed8aa4a,
      0x5b9cca4f,
      0x682e6ff3,
      0x748f82ee,
      0x78a5636f,
      0x84c87814,
      0x8cc70208,
      0x90befffa,
      0xa4506ceb,
      0xbef9a3f7,
      0xc67178f2
    ];

    int h0 = 0x6a09e667,
        h1 = 0xbb67ae85,
        h2 = 0x3c6ef372,
        h3 = 0xa54ff53a,
        h4 = 0x510e527f,
        h5 = 0x9b05688c,
        h6 = 0x1f83d9ab,
        h7 = 0x5be0cd19;
    Uint32List w = new Uint32List(64);

    void blocks(Uint32List p) {
      int off = 0, len = p.length;
      while (len >= 64) {
        int a = h0,
            b = h1,
            c = h2,
            d = h3,
            e = h4,
            f = h5,
            g = h6,
            h = h7,
            u,
            i,
            j,
            t1,
            t2;

        for (i = 0; i < 16; i++) {
          j = off + i * 4;
          w[i] = ((p[j] & 0xff) << 24) |
              ((p[j + 1] & 0xff) << 16) |
              ((p[j + 2] & 0xff) << 8) |
              (p[j + 3] & 0xff);
        }

        for (i = 16; i < 64; i++) {
          u = w[i - 2];
          t1 = (((u & 0xFFFFFFFF) >> 17) | (u << (32 - 17))) ^
              (((u & 0xFFFFFFFF) >> 19) | (u << (32 - 19))) ^
              ((u & 0xFFFFFFFF) >> 10);

          u = w[i - 15];
          t2 = (((u & 0xFFFFFFFF) >> 7) | (u << (32 - 7))) ^
              (((u & 0xFFFFFFFF) >> 18) | (u << (32 - 18))) ^
              ((u & 0xFFFFFFFF) >> 3);

          w[i] = (((t1 + w[i - 7]) | 0) + ((t2 + w[i - 16]) | 0)) | 0;
        }

        for (i = 0; i < 64; i++) {
          t1 = (((((((e & 0xFFFFFFFF) >> 6) | (e << (32 - 6))) ^
                              (((e & 0xFFFFFFFF) >> 11) | (e << (32 - 11))) ^
                              (((e & 0xFFFFFFFF) >> 25) | (e << (32 - 25)))) +
                          ((e & f) ^ (~e & g))) |
                      0) +
                  ((h + ((K[i] + w[i]) | 0)) | 0)) |
              0;

          t2 = (((((a & 0xFFFFFFFF) >> 2) | (a << (32 - 2))) ^
                      (((a & 0xFFFFFFFF) >> 13) | (a << (32 - 13))) ^
                      (((a & 0xFFFFFFFF) >> 22) | (a << (32 - 22)))) +
                  ((a & b) ^ (a & c) ^ (b & c))) |
              0;

          h = g;
          g = f;
          f = e;
          e = (d + t1) | 0;
          d = c;
          c = b;
          b = a;
          a = (t1 + t2) | 0;
        }

        h0 = (h0 + a) | 0;
        h1 = (h1 + b) | 0;
        h2 = (h2 + c) | 0;
        h3 = (h3 + d) | 0;
        h4 = (h4 + e) | 0;
        h5 = (h5 + f) | 0;
        h6 = (h6 + g) | 0;
        h7 = (h7 + h) | 0;

        off += 64;
        len -= 64;
      }
    }

    blocks(m);

    int i,
        bytesLeft = m.length % 64,
        bitLenHi = (m.length / 0x20000000).floor() | 0,
        bitLenLo = m.length << 3,
        numZeros = (bytesLeft < 56) ? 56 : 120;
    Uint32List p = new Uint32List(numZeros + 9);
    int pi = bytesLeft;
    p.setRange(0, bytesLeft, m.sublist(m.length - bytesLeft, m.length));
    //m.sublist(m.length - bytesLeft, m.length);

    p[pi++] = (0x80);
    for (i = bytesLeft + 1; i < numZeros; i++) p[i] = (0);
    pi += (numZeros - (bytesLeft + 1));
    p[pi++] = (((bitLenHi & 0xFFFFFFFF) >> 24) & 0xff);
    p[pi++] = (((bitLenHi & 0xFFFFFFFF) >> 16) & 0xff);
    p[pi++] = (((bitLenHi & 0xFFFFFFFF) >> 8) & 0xff);
    p[pi++] = (((bitLenHi & 0xFFFFFFFF) >> 0) & 0xff);
    p[pi++] = (((bitLenLo & 0xFFFFFFFF) >> 24) & 0xff);
    p[pi++] = (((bitLenLo & 0xFFFFFFFF) >> 16) & 0xff);
    p[pi++] = (((bitLenLo & 0xFFFFFFFF) >> 8) & 0xff);
    p[pi++] = (((bitLenLo & 0xFFFFFFFF) >> 0) & 0xff);

    blocks(p);

    return new Uint32List.fromList([
      ((h0 & 0xFFFFFFFF) >> 24) & 0xff,
      ((h0 & 0xFFFFFFFF) >> 16) & 0xff,
      ((h0 & 0xFFFFFFFF) >> 8) & 0xff,
      ((h0 & 0xFFFFFFFF) >> 0) & 0xff,
      ((h1 & 0xFFFFFFFF) >> 24) & 0xff,
      ((h1 & 0xFFFFFFFF) >> 16) & 0xff,
      ((h1 & 0xFFFFFFFF) >> 8) & 0xff,
      ((h1 & 0xFFFFFFFF) >> 0) & 0xff,
      ((h2 & 0xFFFFFFFF) >> 24) & 0xff,
      ((h2 & 0xFFFFFFFF) >> 16) & 0xff,
      ((h2 & 0xFFFFFFFF) >> 8) & 0xff,
      ((h2 & 0xFFFFFFFF) >> 0) & 0xff,
      ((h3 & 0xFFFFFFFF) >> 24) & 0xff,
      ((h3 & 0xFFFFFFFF) >> 16) & 0xff,
      ((h3 & 0xFFFFFFFF) >> 8) & 0xff,
      ((h3 & 0xFFFFFFFF) >> 0) & 0xff,
      ((h4 & 0xFFFFFFFF) >> 24) & 0xff,
      ((h4 & 0xFFFFFFFF) >> 16) & 0xff,
      ((h4 & 0xFFFFFFFF) >> 8) & 0xff,
      ((h4 & 0xFFFFFFFF) >> 0) & 0xff,
      ((h5 & 0xFFFFFFFF) >> 24) & 0xff,
      ((h5 & 0xFFFFFFFF) >> 16) & 0xff,
      ((h5 & 0xFFFFFFFF) >> 8) & 0xff,
      ((h5 & 0xFFFFFFFF) >> 0) & 0xff,
      ((h6 & 0xFFFFFFFF) >> 24) & 0xff,
      ((h6 & 0xFFFFFFFF) >> 16) & 0xff,
      ((h6 & 0xFFFFFFFF) >> 8) & 0xff,
      ((h6 & 0xFFFFFFFF) >> 0) & 0xff,
      ((h7 & 0xFFFFFFFF) >> 24) & 0xff,
      ((h7 & 0xFFFFFFFF) >> 16) & 0xff,
      ((h7 & 0xFFFFFFFF) >> 8) & 0xff,
      ((h7 & 0xFFFFFFFF) >> 0) & 0xff
    ]);
  }

  Uint32List PBKDF2_HMAC_SHA256_OneIter(
      Uint32List password, Uint32List salt, int dkLen) {
    // compress password if it's longer than hash block length
    if (password.length > 64) {
      // SHA256 expects password to be an Array. If it's not
      // (i.e. it doesn't have .push method), convert it to one.
      password = SHA256(new Uint32List.fromList(password));
    }

    int i, innerLen = 64 + salt.length + 4;
    Uint32List inner = new Uint32List(innerLen),
        outerKey = new Uint32List(64),
        dk = new Uint32List(dkLen);

    // inner = (password ^ ipad) || salt || counter
    for (i = 0; i < 64; i++) inner[i] = 0x36;
    for (i = 0; i < password.length; i++) inner[i] ^= password[i];
    for (i = 0; i < salt.length; i++) inner[64 + i] = salt[i];
    for (i = innerLen - 4; i < innerLen; i++) inner[i] = 0;

    // outerKey = password ^ opad
    for (i = 0; i < 64; i++) outerKey[i] = 0x5c;
    for (i = 0; i < password.length; i++) outerKey[i] ^= password[i];

    // increments counter inside inner
    void incrementCounter() {
      for (int i = innerLen - 1; i >= innerLen - 4; i--) {
        inner[i]++;
        if (inner[i] <= 0xff) return;
        inner[i] = 0;
      }
    }

    // output blocks = SHA256(outerKey || SHA256(inner)) ...
    int dki = 0;
    while (dkLen >= 32) {
      incrementCounter();
      final f = SHA256(new Uint32List.fromList(outerKey + (SHA256(inner))));
      dk..setRange(dki, dki + f.length, f);
      dki += f.length;
      dkLen -= 32;
    }
    if (dkLen > 0) {
      incrementCounter();
      final f = SHA256(new Uint32List.fromList(outerKey + (SHA256(inner))))
          .sublist(0, dkLen);
      dk..setRange(dki, dki + f.length, f);
      dki += f.length;
    }
    return dk;
  }

  void salsaXOR(Uint32List tmp, Uint32List B, int bin, int bout) {
    int j0 = tmp[0] ^ B[bin++],
        j1 = tmp[1] ^ B[bin++],
        j2 = tmp[2] ^ B[bin++],
        j3 = tmp[3] ^ B[bin++],
        j4 = tmp[4] ^ B[bin++],
        j5 = tmp[5] ^ B[bin++],
        j6 = tmp[6] ^ B[bin++],
        j7 = tmp[7] ^ B[bin++],
        j8 = tmp[8] ^ B[bin++],
        j9 = tmp[9] ^ B[bin++],
        j10 = tmp[10] ^ B[bin++],
        j11 = tmp[11] ^ B[bin++],
        j12 = tmp[12] ^ B[bin++],
        j13 = tmp[13] ^ B[bin++],
        j14 = tmp[14] ^ B[bin++],
        j15 = tmp[15] ^ B[bin++],
        u,
        i;

    int x0 = j0,
        x1 = j1,
        x2 = j2,
        x3 = j3,
        x4 = j4,
        x5 = j5,
        x6 = j6,
        x7 = j7,
        x8 = j8,
        x9 = j9,
        x10 = j10,
        x11 = j11,
        x12 = j12,
        x13 = j13,
        x14 = j14,
        x15 = j15;

    for (i = 0; i < 8; i += 2) {
      u = x0 + x12;
      x4 ^= u << 7 | (u & 0xFFFFFFFF) >> (32 - 7);
      u = x4 + x0;
      x8 ^= u << 9 | (u & 0xFFFFFFFF) >> (32 - 9);
      u = x8 + x4;
      x12 ^= u << 13 | (u & 0xFFFFFFFF) >> (32 - 13);
      u = x12 + x8;
      x0 ^= u << 18 | (u & 0xFFFFFFFF) >> (32 - 18);

      u = x5 + x1;
      x9 ^= u << 7 | (u & 0xFFFFFFFF) >> (32 - 7);
      u = x9 + x5;
      x13 ^= u << 9 | (u & 0xFFFFFFFF) >> (32 - 9);
      u = x13 + x9;
      x1 ^= u << 13 | (u & 0xFFFFFFFF) >> (32 - 13);
      u = x1 + x13;
      x5 ^= u << 18 | (u & 0xFFFFFFFF) >> (32 - 18);

      u = x10 + x6;
      x14 ^= u << 7 | (u & 0xFFFFFFFF) >> (32 - 7);
      u = x14 + x10;
      x2 ^= u << 9 | (u & 0xFFFFFFFF) >> (32 - 9);
      u = x2 + x14;
      x6 ^= u << 13 | (u & 0xFFFFFFFF) >> (32 - 13);
      u = x6 + x2;
      x10 ^= u << 18 | (u & 0xFFFFFFFF) >> (32 - 18);

      u = x15 + x11;
      x3 ^= u << 7 | (u & 0xFFFFFFFF) >> (32 - 7);
      u = x3 + x15;
      x7 ^= u << 9 | (u & 0xFFFFFFFF) >> (32 - 9);
      u = x7 + x3;
      x11 ^= u << 13 | (u & 0xFFFFFFFF) >> (32 - 13);
      u = x11 + x7;
      x15 ^= u << 18 | (u & 0xFFFFFFFF) >> (32 - 18);

      u = x0 + x3;
      x1 ^= u << 7 | (u & 0xFFFFFFFF) >> (32 - 7);
      u = x1 + x0;
      x2 ^= u << 9 | (u & 0xFFFFFFFF) >> (32 - 9);
      u = x2 + x1;
      x3 ^= u << 13 | (u & 0xFFFFFFFF) >> (32 - 13);
      u = x3 + x2;
      x0 ^= u << 18 | (u & 0xFFFFFFFF) >> (32 - 18);

      u = x5 + x4;
      x6 ^= u << 7 | (u & 0xFFFFFFFF) >> (32 - 7);
      u = x6 + x5;
      x7 ^= u << 9 | (u & 0xFFFFFFFF) >> (32 - 9);
      u = x7 + x6;
      x4 ^= u << 13 | (u & 0xFFFFFFFF) >> (32 - 13);
      u = x4 + x7;
      x5 ^= u << 18 | (u & 0xFFFFFFFF) >> (32 - 18);

      u = x10 + x9;
      x11 ^= u << 7 | (u & 0xFFFFFFFF) >> (32 - 7);
      u = x11 + x10;
      x8 ^= u << 9 | (u & 0xFFFFFFFF) >> (32 - 9);
      u = x8 + x11;
      x9 ^= u << 13 | (u & 0xFFFFFFFF) >> (32 - 13);
      u = x9 + x8;
      x10 ^= u << 18 | (u & 0xFFFFFFFF) >> (32 - 18);

      u = x15 + x14;
      x12 ^= u << 7 | (u & 0xFFFFFFFF) >> (32 - 7);
      u = x12 + x15;
      x13 ^= u << 9 | (u & 0xFFFFFFFF) >> (32 - 9);
      u = x13 + x12;
      x14 ^= u << 13 | (u & 0xFFFFFFFF) >> (32 - 13);
      u = x14 + x13;
      x15 ^= u << 18 | (u & 0xFFFFFFFF) >> (32 - 18);
    }

    B[bout++] = tmp[0] = (x0 + j0) | 0;
    B[bout++] = tmp[1] = (x1 + j1) | 0;
    B[bout++] = tmp[2] = (x2 + j2) | 0;
    B[bout++] = tmp[3] = (x3 + j3) | 0;
    B[bout++] = tmp[4] = (x4 + j4) | 0;
    B[bout++] = tmp[5] = (x5 + j5) | 0;
    B[bout++] = tmp[6] = (x6 + j6) | 0;
    B[bout++] = tmp[7] = (x7 + j7) | 0;
    B[bout++] = tmp[8] = (x8 + j8) | 0;
    B[bout++] = tmp[9] = (x9 + j9) | 0;
    B[bout++] = tmp[10] = (x10 + j10) | 0;
    B[bout++] = tmp[11] = (x11 + j11) | 0;
    B[bout++] = tmp[12] = (x12 + j12) | 0;
    B[bout++] = tmp[13] = (x13 + j13) | 0;
    B[bout++] = tmp[14] = (x14 + j14) | 0;
    B[bout++] = tmp[15] = (x15 + j15) | 0;
  }

  void blockCopy(Uint32List dst, int di, Uint32List src, int si, int len) {
    while (len-- > 0) dst[di++] = src[si++];
  }

  void blockXOR(Uint32List dst, int di, Uint32List src, int si, int len) {
    while (len-- > 0) dst[di++] ^= src[si++];
  }

  void blockMix(Uint32List tmp, Uint32List B, int bin, int bout, int r) {
    blockCopy(tmp, 0, B, bin + (2 * r - 1) * 16, 16);
    for (int i = 0; i < 2 * r; i += 2) {
      salsaXOR(tmp, B, bin + i * 16, bout + i * 8);
      salsaXOR(tmp, B, bin + i * 16 + 16, bout + i * 8 + r * 16);
    }
  }

  Uint32List XY = new Uint32List(64 * r);
  Uint32List V = new Uint32List(32 * r * N);
  Uint32List tmp = new Uint32List(16);

  int xi = 0, yi = 32 * r;

  Uint32List B = PBKDF2_HMAC_SHA256_OneIter(
      stringToUTF8Bytes(password), stringToUTF8Bytes(salt), p * 128 * r);

  int integerify(Uint32List B, int bi, int r) {
    return B[bi + (2 * r - 1) * 16];
  }

  void smixStart(int pos) {
    for (int i = 0; i < 32 * r; i++) {
      int j = pos + i * 4;
      XY[xi + i] = ((B[j + 3] & 0xff) << 24) |
          ((B[j + 2] & 0xff) << 16) |
          ((B[j + 1] & 0xff) << 8) |
          ((B[j + 0] & 0xff) << 0);
    }
  }

  void smixStep1(int start, int end) {
    for (int i = start; i < end; i += 2) {
      blockCopy(V, i * (32 * r), XY, xi, 32 * r);
      blockMix(tmp, XY, xi, yi, r);

      blockCopy(V, (i + 1) * (32 * r), XY, yi, 32 * r);
      blockMix(tmp, XY, yi, xi, r);
    }
  }

  void smixStep2(int start, int end) {
    for (int i = start; i < end; i += 2) {
      int j = integerify(XY, xi, r) & (N - 1);
      blockXOR(XY, xi, V, j * (32 * r), 32 * r);
      blockMix(tmp, XY, xi, yi, r);

      j = integerify(XY, yi, r) & (N - 1);
      blockXOR(XY, yi, V, j * (32 * r), 32 * r);
      blockMix(tmp, XY, yi, xi, r);
    }
  }

  void smixFinish(int pos) {
    for (int i = 0; i < 32 * r; i++) {
      int j = XY[xi + i];
      B[pos + i * 4 + 0] = ((j & 0xFFFFFFFF) >> 0) & 0xff;
      B[pos + i * 4 + 1] = ((j & 0xFFFFFFFF) >> 8) & 0xff;
      B[pos + i * 4 + 2] = ((j & 0xFFFFFFFF) >> 16) & 0xff;
      B[pos + i * 4 + 3] = ((j & 0xFFFFFFFF) >> 24) & 0xff;
    }
  }

  // Generate key.
  int MAX_UINT = 0x7fffffff;
  if (N < 2 || N > MAX_UINT) {
    //  scrypt: N is out of range
    throw new Error();
  }
  if ((N & (N - 1)) != 0) {
    //  scrypt: N is not a power of 2
    throw new Error();
  }
  if (p < 1) {
    //  scrypt: invalid p
    throw new Error();
  }

  if (r <= 0) {
    //  scrypt: invalid r
    throw new Error();
  }

  for (int i = 0; i < p; i++) {
    smixStart(i * 128 * r);
    smixStep1(0, N);
    smixStep2(0, N);
    smixFinish(i * 128 * r);
  }

  return PBKDF2_HMAC_SHA256_OneIter(stringToUTF8Bytes(password), B, dkLen);
}
