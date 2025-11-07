/*
/// Module: contador
module contador::contador;
*/

module contador::contador {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};

    #[error]
    const ECOUNTER_OVERFLOW: u64 = 1;

    public struct Counter has key {
        id: UID,
        current: u64,
        target: u64,
    }

    public struct CounterCap has drop {}

    /// Cria um novo contador e retorna o capability e o objeto Counter.
    public fun new(target: u64, ctx: &mut TxContext): (CounterCap, Counter) {
        let counter = Counter { id: object::new(ctx), current: 0, target };
        let cap = CounterCap {};
        (cap, counter)
    }

    public fun increment(_cap: &CounterCap, counter: &mut Counter) {
        assert!(counter.current < counter.target, ECOUNTER_OVERFLOW);
        counter.current = counter.current + 1;
    }

    public fun is_completed(counter: &Counter): bool {
        counter.current == counter.target
    }

    public fun reset(_cap: &CounterCap, counter: &mut Counter) {
        counter.current = 0;
    }

    #[test]
    fun test_increment_and_reset(ctx: &mut TxContext) {
        let (cap, mut counter) = new(3, ctx);
        increment(&cap, &mut counter);
        assert!(counter.current == 1, 0);
        reset(&cap, &mut counter);
        assert!(counter.current == 0, 1);
    }
}

