*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcx_no_connection DEFINITION INHERITING FROM cx_static_check.

  PUBLIC SECTION.

    INTERFACES if_t100_message.

    METHODS constructor
      IMPORTING
        textid           LIKE if_t100_message=>t100key OPTIONAL
        previous         LIKE previous OPTIONAL
        airlineid        TYPE /dmo/carrier_id OPTIONAL
        connectionnumber TYPE /dmo/connection_id OPTIONAL.

    CONSTANTS:
      BEGIN OF lcx_no_connection,
        msgid TYPE symsgid VALUE 'Z5952_EXCEPTIONS',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'AIRLINEID',
        attr2 TYPE scx_attrname VALUE 'CONNECTIONNUMBER',
        attr3 TYPE scx_attrname VALUE 'attr3',
        attr4 TYPE scx_attrname VALUE 'attr4',
      END OF lcx_no_connection.

    DATA: airlineid        TYPE /dmo/carrier_id READ-ONLY,
          connectionnumber TYPE /dmo/connection_id READ-ONLY.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcx_no_connection IMPLEMENTATION.

  METHOD constructor.

    super->constructor( previous = previous ).

    me->airlineid = airlineid.
    me->connectionnumber = connectionnumber.

    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = lcx_no_connection.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_connection DEFINITION.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        i_airlineid        TYPE /dmo/carrier_id
        i_connectionnumber TYPE /dmo/connection_id
      RAISING
        lcx_no_connection.


  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: AirlineId        TYPE /dmo/carrier_id,
          ConnectionNumber TYPE /dmo/connection_id,
          fromAirportId    TYPE /dmo/airport_from_id,
          toAirportId      TYPE /dmo/airport_to_id.

ENDCLASS.

CLASS lcl_connection IMPLEMENTATION.

  METHOD constructor.

    DATA: fromairport TYPE /dmo/airport_from_id,
          toairport   TYPE /dmo/airport_to_id.

    SELECT SINGLE FROM /dmo/connection
    FIELDS airport_from_id, airport_to_id
    WHERE carrier_id = @i_airlineid
    AND connection_id = @i_connectionnumber
    INTO  ( @fromairport, @toairport ).

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE lcx_no_connection
        EXPORTING
          airlineid        = i_airlineid
          connectionnumber = i_connectionnumber.
    ELSE.

      me->ConnectionNumber = i_connectionnumber.
      me->fromAirportId = fromairport.
      me->toAirportId = toairport.

    ENDIF.

  ENDMETHOD.

ENDCLASS.
