page 70106 SalesShipmentAPI
{
    PageType = API;
    Caption = 'salesShipmentAPI';
    APIPublisher = 'kpmg';
    APIGroup = 'kpmg';
    APIVersion = 'v2.0';
    EntityName = 'salesShipmentAPI';
    EntitySetName = 'salesShipmentAPI';
    SourceTable = "Sales Shipment Header";
    DelayedInsert = true;
    ODataKeyFields = SystemId;


    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("ShipmentNo"; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'Shipment No.';
                }
                field("BilltoCustomerNo"; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("PostingDate"; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                    ApplicationArea = All;
                }
                field(AddressLine1; Rec."Bill-to Address")
                {
                    ApplicationArea = All;
                }
                field("AddressLine2"; Rec."Bill-to Address 2")
                {
                    ApplicationArea = All;
                }
                field(City; Rec."Bill-to City")
                {
                    ApplicationArea = All;
                }
                field(Contact; Rec."Bill-to Contact")
                {
                    ApplicationArea = All;
                }
                field("CountryRegionCode"; Rec."Bill-to Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("EMail"; Rec."Sell-to E-Mail")
                {
                    ApplicationArea = All;

                }
                field(SystemId; Rec.SystemId)
                {
                    ApplicationArea = All;
                    Caption = 'Document Id';
                }
                field("PhoneNo"; Rec."Sell-to Phone No.")
                {
                    ApplicationArea = All;
                    Caption = 'Phone No.';
                }
                field("StateCode"; Rec.State)
                {
                    ApplicationArea = All;
                    Caption = 'State Code';
                }
                field("PostCode"; Rec."Bill-to Post Code")
                {
                    ApplicationArea = All;
                }
                field("PromisedDeliveryDate"; Rec."Promised Delivery Date")
                {
                    ApplicationArea = All;
                    Caption = 'Promised Delivery Date';
                }
                field("RequestedDeliveryDate"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = All;
                    Caption = 'Requested Delivery Date';
                }
                field("LocationCode"; Rec."Location Code")
                {
                    Caption = 'Location Code';
                    ApplicationArea = All;
                }
                field("ExternalDocumentNo"; Rec."External Document No.")
                {
                    Caption = 'External Document No.';
                    ApplicationArea = All;
                }
                field("OrderNo"; Rec."Order No.")
                {
                    Caption = 'Order No.';
                    ApplicationArea = All;
                }

            }
        }
    }
}