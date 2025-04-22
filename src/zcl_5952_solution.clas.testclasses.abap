*"* use this source file for your ABAP unit test classes
class ltcl_find_flights definition final for testing
  duration long
  risk level harmless.

  private section.


  CLASS-DATA the_carrier TYPE REF TO lcl_carrier.
    CLASS-DATA some_flight_data TYPE /lrn/cargoflight.

  CLASS-METHODS class_setup.

    methods:
      test_find_cargo_flight for testing raising cx_static_check.
endclass.


class ltcl_find_flights implementation.

  method test_find_cargo_flight.



    the_carrier->find_cargo_flight(
      EXPORTING
        i_airport_from_id = some_flight_data-airport_from_id
        i_airport_to_id   = some_flight_data-airport_to_id
        i_from_date       = some_flight_data-flight_date
        i_cargo           = 1
      IMPORTING
        e_flight          = data(flight)
        e_days_later      = data(days_later)
    ).


   cl_abap_unit_assert=>assert_bound(
        act = flight
        msg = `Method find_cargo_flight does not return a result`
    ).

    cl_abap_unit_assert=>assert_equals(
        act = days_later
        exp = 0
        msg = `Method find_cargo_flight returns wrong result` ).


  endmethod.


  METHOD class_setup.

    SELECT SINGLE
      FROM /lrn/cargoflight
    FIELDS carrier_id, connection_id, flight_date,
           airport_from_id, airport_to_id
      INTO CORRESPONDING FIELDS OF @some_flight_data.
    IF sy-subrc <> 0.
      cl_abap_unit_assert=>fail( `No data in table /lrn/CARGOFLIGHT` ).
    ENDIF.
    TRY.
        the_carrier = NEW lcl_carrier( i_carrier_id = some_flight_data-carrier_id ).
      CATCH cx_abap_invalid_value.
        cl_abap_unit_assert=>fail( `Unable to instantiate lcl_carrier` ).
    ENDTRY.

ENDMETHOD.


endclass.
