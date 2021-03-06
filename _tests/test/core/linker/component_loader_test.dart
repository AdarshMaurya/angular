@TestOn('browser')
import 'package:test/test.dart';
import 'package:angular/angular.dart';
import 'package:angular_test/angular_test.dart';

// ignore: uri_has_not_been_generated
import 'component_loader_test.template.dart' as ng;

void main() {
  tearDown(disposeAnyRunningTest);

  test('should be able to load next to a location', () async {
    final testBed = NgTestBed.forComponent(ng.CompWithCustomLocationNgFactory);
    final fixture = await testBed.create();
    expect(fixture.text, 'BeforeAfter');
    await fixture.update((comp) {
      comp.loader.loadNextToLocation(
        ng.DynamicCompNgFactory,
        comp.location,
      );
    });
    expect(fixture.text, 'BeforeDynamicAfter');
  });

  test('should be able to load into a structural directive', () async {
    final testBed = NgTestBed.forComponent(ng.CompWithDirectiveNgFactory);
    final fixture = await testBed.create();
    expect(fixture.text, 'BeforeDynamicAfter');
  });

  test('should be able to load from a service', () async {
    final testBed = NgTestBed.forComponent(ng.CompWithServiceNgFactory);
    final fixture = await testBed.create();
    await fixture.update((comp) {
      final ref = comp.service.loader.loadDetached(ng.DynamicCompNgFactory);
      expect(ref.location.text, 'Dynamic');
    });
  });
}

@Component(
  selector: 'comp-with-custom-location',
  template: r'Before<template #location></template>After',
)
class CompWithCustomLocation {
  final ComponentLoader loader;

  CompWithCustomLocation(this.loader);

  @ViewChild('location', read: ViewContainerRef)
  ViewContainerRef location;
}

@Component(
  selector: 'comp-with-directive',
  directives: [
    DirectiveThatIsLocation,
  ],
  template: r'Before<template location></template>After',
)
class CompWithDirective {}

@Directive(
  selector: '[location]',
)
class DirectiveThatIsLocation {
  DirectiveThatIsLocation(ComponentLoader loader) {
    loader.loadNextTo(ng.DynamicCompNgFactory);
  }
}

@Component(
  selector: 'comp-with-service',
  providers: [Service],
  template: '',
)
class CompWithService {
  final Service service;

  CompWithService(this.service);
}

@Injectable()
class Service {
  final ComponentLoader loader;

  Service(this.loader);
}

@Component(
  selector: 'dynamic-comp',
  template: 'Dynamic',
)
class DynamicComp {}
