#[test_only]
module snacks::mercado_tests {
    use snacks::mercado;
    use sui::test_scenario as ts;
    use std::string;

    const ADMIN: address = @0xAD;

    // Test 1: Crear mercado
    #[test]
    fun test_crear_mercado() {
        let mut scenario = ts::begin(ADMIN);
        
        ts::next_tx(&mut scenario, ADMIN);
        {
            mercado::crear_mercado(
                string::utf8(b"Mercado Central"),
                ts::ctx(&mut scenario)
            );
        };

        ts::next_tx(&mut scenario, ADMIN);
        {
            let mercado_obj = ts::take_from_sender(&scenario);
            ts::return_to_sender(&scenario, mercado_obj);
        };

        ts::end(scenario);
    }

    // Test 2: Registrar vendedor
    #[test]
    fun test_registrar_vendedor() {
        let mut scenario = ts::begin(ADMIN);
        
        ts::next_tx(&mut scenario, ADMIN);
        {
            mercado::crear_mercado(
                string::utf8(b"Mi Mercado"),
                ts::ctx(&mut scenario)
            );
        };

        ts::next_tx(&mut scenario, ADMIN);
        {
            let mut mercado_obj = ts::take_from_sender(&scenario);
            mercado::registrar_vendedor(
                &mut mercado_obj,
                string::utf8(b"Juan Vendedor"),
                1
            );
            ts::return_to_sender(&scenario, mercado_obj);
        };

        ts::end(scenario);
    }

    // Test 3: Registrar cliente
    #[test]
    fun test_registrar_cliente() {
        let mut scenario = ts::begin(ADMIN);
        
        ts::next_tx(&mut scenario, ADMIN);
        {
            mercado::crear_mercado(
                string::utf8(b"Mi Mercado"),
                ts::ctx(&mut scenario)
            );
        };

        ts::next_tx(&mut scenario, ADMIN);
        {
            let mut mercado_obj = ts::take_from_sender(&scenario);
            mercado::registrar_cliente(
                &mut mercado_obj,
                string::utf8(b"Maria Cliente"),
                1
            );
            ts::return_to_sender(&scenario, mercado_obj);
        };

        ts::end(scenario);
    }

    // Test 4: Agregar stock
    #[test]
    fun test_agregar_stock() {
        let mut scenario = ts::begin(ADMIN);
        
        ts::next_tx(&mut scenario, ADMIN);
        {
            mercado::crear_mercado(
                string::utf8(b"Mi Mercado"),
                ts::ctx(&mut scenario)
            );
        };

        ts::next_tx(&mut scenario, ADMIN);
        {
            let mut mercado_obj = ts::take_from_sender(&scenario);
            mercado::registrar_vendedor(
                &mut mercado_obj,
                string::utf8(b"Vendedor 1"),
                1
            );
            mercado::agregar_stock(
                &mut mercado_obj,
                1,
                string::utf8(b"Cheetos"),
                100
            );
            ts::return_to_sender(&scenario, mercado_obj);
        };

        ts::end(scenario);
    }

    // Test 5: Comprar snack
    #[test]
    fun test_comprar_snack() {
        let mut scenario = ts::begin(ADMIN);
        
        ts::next_tx(&mut scenario, ADMIN);
        {
            mercado::crear_mercado(
                string::utf8(b"Mi Mercado"),
                ts::ctx(&mut scenario)
            );
        };

        ts::next_tx(&mut scenario, ADMIN);
        {
            let mut mercado_obj = ts::take_from_sender(&scenario);
            
            mercado::registrar_vendedor(
                &mut mercado_obj,
                string::utf8(b"Vendedor 1"),
                1
            );
            
            mercado::registrar_cliente(
                &mut mercado_obj,
                string::utf8(b"Cliente 1"),
                1
            );
            
            mercado::agregar_stock(
                &mut mercado_obj,
                1,
                string::utf8(b"Cheetos"),
                100
            );
            
            let _mensaje = mercado::comprar_snack(
                &mut mercado_obj,
                1,
                1,
                string::utf8(b"Cheetos"),
                10
            );
            
            ts::return_to_sender(&scenario, mercado_obj);
        };

        ts::end(scenario);
    }

    // Test 6: Obtener estado del cliente
    #[test]
    fun test_obtener_estado_cliente() {
        let mut scenario = ts::begin(ADMIN);
        
        ts::next_tx(&mut scenario, ADMIN);
        {
            mercado::crear_mercado(
                string::utf8(b"Mi Mercado"),
                ts::ctx(&mut scenario)
            );
        };

        ts::next_tx(&mut scenario, ADMIN);
        {
            let mut mercado_obj = ts::take_from_sender(&scenario);
            
            mercado::registrar_cliente(
                &mut mercado_obj,
                string::utf8(b"Ana Lopez"),
                1
            );
            
            let _estado = mercado::obtener_estado_cliente(&mercado_obj, 1);
            
            ts::return_to_sender(&scenario, mercado_obj);
        };

        ts::end(scenario);
    }

    // Test 7: Eliminar vendedor
    #[test]
    fun test_eliminar_vendedor() {
        let mut scenario = ts::begin(ADMIN);
        
        ts::next_tx(&mut scenario, ADMIN);
        {
            mercado::crear_mercado(
                string::utf8(b"Mi Mercado"),
                ts::ctx(&mut scenario)
            );
        };

        ts::next_tx(&mut scenario, ADMIN);
        {
            let mut mercado_obj = ts::take_from_sender(&scenario);
            
            mercado::registrar_vendedor(
                &mut mercado_obj,
                string::utf8(b"Vendedor Temporal"),
                1
            );
            
            mercado::eliminar_vendedor(&mut mercado_obj, 1);
            
            ts::return_to_sender(&scenario, mercado_obj);
        };

        ts::end(scenario);
    }

    // Test 8: Eliminar cliente
    #[test]
    fun test_eliminar_cliente() {
        let mut scenario = ts::begin(ADMIN);
        
        ts::next_tx(&mut scenario, ADMIN);
        {
            mercado::crear_mercado(
                string::utf8(b"Mi Mercado"),
                ts::ctx(&mut scenario)
            );
        };

        ts::next_tx(&mut scenario, ADMIN);
        {
            let mut mercado_obj = ts::take_from_sender(&scenario);
            
            mercado::registrar_cliente(
                &mut mercado_obj,
                string::utf8(b"Cliente Temporal"),
                1
            );
            
            mercado::eliminar_cliente(&mut mercado_obj, 1);
            
            ts::return_to_sender(&scenario, mercado_obj);
        };

        ts::end(scenario);
    }

    // Test 9: Eliminar mercado
    #[test]
    fun test_eliminar_mercado() {
        let mut scenario = ts::begin(ADMIN);
        
        ts::next_tx(&mut scenario, ADMIN);
        {
            mercado::crear_mercado(
                string::utf8(b"Mercado Temporal"),
                ts::ctx(&mut scenario)
            );
        };

        ts::next_tx(&mut scenario, ADMIN);
        {
            let mercado_obj = ts::take_from_sender(&scenario);
            mercado::eliminar_mercado(mercado_obj);
        };

        ts::end(scenario);
    }
}
