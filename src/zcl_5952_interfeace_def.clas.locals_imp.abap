*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
INTERFACE lif_partner.
  METHODS get_parter_attributes.
ENDINTERFACE.


CLASS lcl_travel_agency DEFINITION.

  PUBLIC SECTION.

ENDCLASS.

CLASS lcl_airline DEFINITION.

  PUBLIC SECTION.

    INTERFACES lif_partner.

    TYPES: BEGIN OF ts_detail,
             name  TYPE string,
             value TYPE string,
           END OF ts_detail,
           tt_detail TYPE SORTED TABLE OF ts_detail WITH UNIQUE KEY name.

    METHODS get_details RETURNING VALUE(rt_details) TYPE tt_detail.

ENDCLASS.

CLASS lcl_car_rental DEFINITION.

  PUBLIC SECTION.
    INTERFACES lif_partner.
    TYPES:BEGIN OF ts_info,
            name  TYPE string,
            value TYPE string,
          END OF ts_info,
          tt_info TYPE SORTED TABLE OF ts_info WITH UNIQUE KEY name.

    METHODS get_information RETURNING VALUE(rt_info) TYPE tt_info.

ENDCLASS.

CLASS lcl_car_rental IMPLEMENTATION.

  METHOD get_information.

  ENDMETHOD.

  METHOD lif_partner~get_parter_attributes.

  ENDMETHOD.

ENDCLASS.


CLASS lcl_airline IMPLEMENTATION.

  METHOD get_details.

  ENDMETHOD.

  METHOD lif_partner~get_parter_attributes.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_travel_agency IMPLEMENTATION.

ENDCLASS.
