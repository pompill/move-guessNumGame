module guessNumGame::guessNumGame{
    // use sui::random::{Self};
    // use sui::hash::{Self};
    // use std::string::utf8;
    // use std::debug::{Self};
    // use std::vector::{Self};
    use sui::tx_context;
    use sui::transfer::{Self};
    use sui::object;
    use sui::tx_context::TxContext;
    use sui::object::{UID};

    struct RandomKey has key, store{
        id : UID,
        value : u64,
        count : u64
    }

    struct GuessResult has key, store{
        id : UID,
        count : u64,
        win : bool,
        yourNum : u64,
        actualNum : u64
    }

    // #[test]
    // fun testRandom(){
    //     let data = vector<u64>[
    //         1
    //     ];
    //     let h = hash::blake2b256(&data);
    //     debug::print(&1);
    //     let value = vector::pop_back(&mut h);
    //     let a = generate_pseudo_random_number(value);
    //     debug::print(&a);
    // }

    fun init(ctx : &mut TxContext){
        let rk = RandomKey{
            id : object::new(ctx),
            value : 1,
            count : 0
        };
        transfer::share_object(rk)
    }

    public entry fun StartGame(myNum : u64, rk : &mut RandomKey, ctx : &mut TxContext){
        let systemNum = generate_pseudo_random_number(rk.value);

        let result = false;

        if (systemNum == myNum){
            result = true;
        };

        rk.count = rk.count + 1;
        let r = GuessResult{
            id : object::new(ctx),
            count : rk.count,
            win : result,
            yourNum : myNum,
            actualNum : systemNum
        };

        rk.value = rk.value + systemNum + rk.count;
        transfer::public_transfer(r, tx_context::sender(ctx))
    }

    // 通过哈希地址生成1到6的伪随机数
    public fun generate_pseudo_random_number(hashAddr : u64): u64 {
        let pseudo_random_number = hashAddr % 6 + 1;
        pseudo_random_number
    }
}