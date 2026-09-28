import 'dart:async';

/// Emits `combine(a, b)` whenever either source emits, once both have a value.
Stream<R> combineLatest2<A, B, R>(Stream<A> a, Stream<B> b, R Function(A a, B b) combine) {
  return Stream<R>.multi((controller) {
    A? lastA;
    B? lastB;
    var hasA = false;
    var hasB = false;
    var doneA = false;
    var doneB = false;

    void emit() {
      if (hasA && hasB) controller.add(combine(lastA as A, lastB as B));
    }

    void maybeClose() {
      if (doneA && doneB) controller.close();
    }

    final subA = a.listen((v) {
      lastA = v;
      hasA = true;
      emit();
    }, onError: controller.addError, onDone: () {
      doneA = true;
      maybeClose();
    });
    final subB = b.listen((v) {
      lastB = v;
      hasB = true;
      emit();
    }, onError: controller.addError, onDone: () {
      doneB = true;
      maybeClose();
    });

    controller.onCancel = () async {
      await subA.cancel();
      await subB.cancel();
    };
  });
}
