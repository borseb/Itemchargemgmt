table 70102 DebitNoteWorksheetKPMG
{
    DataClassification = CustomerContent;
    Caption = 'Debit Note Worksheet';

    fields
    {
        field(70100; "Sales Order No."; Code[50])
        {
            Caption = 'Sales Order No.';
        }
        field(70101; "Customer No."; Code[50])
        {
            Caption = 'Customer No.';
        }
        field(70102; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(70103; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(70104; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';
        }
        field(70105; "Location Code"; Code[50])
        {
            Caption = 'Location Code';
        }
        field(70106; "Location Type"; Option)
        {
            Caption = 'Location Type';
            OptionMembers = Warehouse,Port;
            OptionCaption = 'Warehouse,Port';
        }
        field(70107; "Total Days"; Integer)
        {
            Caption = 'Total Days';
        }
        field(70108; "Total Months"; Integer)
        {
            Caption = 'Total Months';
        }
        field(70109; "Total Charges"; Decimal)
        {
            Caption = 'Actual Charges';
            Editable = false;
        }
        field(70110; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(70111; "Sales Shipment No."; Code[20])
        {
            Caption = 'Sales Shipment No.';
        }
        field(70112; "Status"; Option)
        {
            Caption = 'Status';
            OptionMembers = Pending,Approved,Rejected;
            OptionCaption = 'Pending,Approved,Rejected';
        }
        field(70113; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
        }
        field(70114; "Sales Invoice No."; Code[20])
        {
            Caption = 'Sales Invoice No.';
            DataClassification = CustomerContent;
        }
        field(70115; "0-30Days"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = '0-30 Days';
        }
        field(70116; "31-60Days"; Decimal)
        {
            Caption = '31-60 Days';
            DataClassification = CustomerContent;
        }
        field(70117; "61-90Days"; Decimal)
        {
            Caption = '61-90 Days';
            DataClassification = CustomerContent;
        }
        field(70118; "Charge per month"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Charge per month';
        }
        field(70119; "Final Charges"; Decimal)
        {
            Caption = 'Final Charges';
        }
        field(70120; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
    }

    keys
    {
        key(Key1; "Sales Order No.", "Sales Shipment No.", "Customer No.", "Posting Date", "Promised Delivery Date", "Location Code", "Item Category Code")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}