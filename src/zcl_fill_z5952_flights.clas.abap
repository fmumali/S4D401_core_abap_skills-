CLASS zcl_fill_z5952_flights DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_fill_z5952_flights IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA flights TYPE TABLE OF /dmo/flight.
    DATA insert_tab TYPE TABLE OF /dmo/flight.

    DELETE FROM z5952_flights.

    SELECT FROM /dmo/flight FIELDS * ORDER BY carrier_id, connection_id INTO TABLE @flights.

    LOOP AT flights ASSIGNING FIELD-SYMBOL(<first_date>).

*    Original table flights has 2 flights per connection. Only process the first.

      IF sy-tabix MOD 2 = 0.
        CONTINUE.
      ENDIF.

* Extend flight dates by 2000 days.
      DO 2000 TIMES.
        APPEND <first_date> TO insert_tab.
        <first_date>-flight_date  +=  1.
      ENDDO.

    ENDLOOP.

* Read highest connection number for each flight
    SELECT FROM /dmo/flight AS main FIELDS
               carrier_id,
               connection_id,
               flight_date,
               price,
               currency_code,
               plane_type_id
               WHERE connection_id = ( SELECT MAX( connection_id ) FROM /dmo/flight WHERE carrier_id = main~carrier_id  )
               AND flight_date = ( SELECT MIN( flight_date ) FROM /dmo/flight WHERE carrier_id = main~carrier_id AND connection_id = main~connection_id )
               GROUP BY carrier_id, connection_id, flight_date, price, currency_code, plane_type_id
               ORDER BY carrier_id, connection_id
               INTO TABLE @DATA(max).

* Add 50 new connection numbers and 2000 days of flights for each
    LOOP AT max ASSIGNING FIELD-SYMBOL(<line>).

      DO 50 TIMES.
        <line>-connection_id += 1.
        <line>-plane_type_id = SWITCH #( CONV i( <line>-connection_id ) MOD 2 WHEN 0 THEN 'A350' ).

        <first_date> = CORRESPONDING #( <line> ).
        DATA(repetitions) = COND i( WHEN <line>-carrier_id = 'LH' AND <line>-connection_id = '0405' THEN 4000 ELSE 2000 ).
        DO repetitions TIMES.
          <first_date>-seats_max = 220.
          APPEND <first_date> TO insert_tab.
          <first_date>-flight_date  +=  1.
        ENDDO.

      ENDDO.

    ENDLOOP.

SORT insert_tab BY carrier_id connection_id flight_date.
DELETE ADJACENT DUPLICATES FROM insert_tab cOMPARING carrier_id connection_id flight_date.

INSERT z5952_flights FROM TABLE @insert_tab.
out->write( |Generated { sy-dbcnt } rows in table z5952_flights| ).

  ENDMETHOD.

ENDCLASS.
