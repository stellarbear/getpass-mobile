import 'dart:async';
import 'dart:convert';
import 'package:getpass/src/infrastructure/service.dart';
import 'package:getpass/src/infrastructure/storage.dart';
import 'package:getpass/src/infrastructure/validators.dart';
import 'package:rxdart/rxdart.dart';

class ServiceBloc with Validators {
  static List<Service> _services = List<Service>();

  final _selectedServiceController = BehaviorSubject<Service>();
  Stream<Service> get selectedServiceStream =>
      _selectedServiceController.stream;
  Function(Service) get selectedServiceOnChange =>
      _selectedServiceController.sink.add;

  final _filterController = BehaviorSubject<String>(seedValue: '');
  Stream<String> get filterStream => _filterController.stream;
  Function(String) get filterOnChange => _filterController.sink.add;

  final _newServiceController = BehaviorSubject<Service>();
  Stream<Service> get newServiceStream => _newServiceController.stream
      .transform(validateServices(uniqueList: _services));
  Function(Service) get newServiceOnChange => _newServiceController.sink.add;

  final _editServiceController = BehaviorSubject<Service>();
  Stream<Service> get editServiceStream => _editServiceController.stream;
  Function(Service) get editServiceOnChange => _editServiceController.sink.add;

  BehaviorSubject<List<Service>> _servicesController =
      BehaviorSubject<List<Service>>(seedValue: []);
  List<Service> get serviceList => _servicesController.value;
  Stream<List<Service>> get serviceStream => _servicesController.stream;

  BehaviorSubject<Service> _serviceAddController = BehaviorSubject<Service>();
  Function(Service) get serviceAdd => _serviceAddController.sink.add;

  BehaviorSubject<Service> _serviceRemoveController =
      BehaviorSubject<Service>();
  Function(Service) get serviceRemove => _serviceRemoveController.sink.add;

  ServiceBloc() {
    _serviceAddController.listen(_handleServiceAdd);
    _serviceRemoveController.listen(_handleServiceRemove);
  }

  void _handleServiceAdd(Service input) {
    if ((input.value.length > 0) &&
        (_services.indexWhere((service) => service.value == input.value) ==
            -1)) {
      _services.add(input);
    }

    _servicesController.sink.add(_services);
    updateStorage();
  }

  void _handleServiceRemove(Service input) {
    _services.remove(input);
    _servicesController.sink.add(_services);

    if (_selectedServiceController.value != null) {
      if (input.value == _selectedServiceController.value.value) {
        selectedServiceOnChange(null);
      }
    }
    updateStorage();
  }

  dispose() {
    _serviceAddController.close();
    _serviceRemoveController.close();

    _newServiceController.close();
    _editServiceController.close();

    _servicesController.close();
    _filterController.close();

    _selectedServiceController.close();
  }

  void init() {
    String data = storage.getItem(key: storageKey.services, defaultValue: '');

    try {
      _services = (json.decode(data) as List)
          .map((value) => Service.fromJson(value))
          .toList();
    } catch (ex) {
      _services = List<Service>();
    }
    _servicesController.sink.add(_services);
  }

  void updateStorage() async {
    String data =
        json.encode(_services.map((service) => service.toJson()).toList());

    await storage.setItem(
      value: data,
      key: storageKey.services,
    );

    storage.getItem(key: storageKey.services, defaultValue: '');
  }

  void reset() {
    selectedServiceOnChange(null);
    _services.clear();
    updateStorage();
  }
}

final serviceBloc = ServiceBloc();
