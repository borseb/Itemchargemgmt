table 70103 "Open Provision"
{
    Caption = 'Open Provision';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(3; "PO No."; Code[20])
        {
            Caption = 'PO No.';
        }
        field(4; "BPO No."; Code[20])
        {
            Caption = 'BPO No.';
        }
        field(5; "Receipt No."; Code[20])
        {
            Caption = 'Receipt No.';
        }
        field(6; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(7; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }
        field(8; Commodity; Code[50])
        {
            Caption = 'Commodity';
        }
        field(9; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(10; "Posted Provision"; Decimal)
        {
            Caption = 'Posted Provision';
            FieldClass = FlowField;
            CalcFormula = sum("Value Entry"."Cost Amount (Actual)" where("Charge(Item) Type KPMG" = const(Provisional), "Item Ledger Entry No." = field("Item Ledger Entry No")));
        }
        field(11; "Reversed Provision"; Decimal)
        {
            Caption = 'Reversed Provision';
            FieldClass = FlowField;
            CalcFormula = sum("Value Entry"."Cost Amount (Actual)" where("Charge(Item) Type KPMG CR" = const(Provisional), "Item Ledger Entry No." = field("Item Ledger Entry No")));
        }
        field(12; "Remaning Open Provision"; Decimal)
        {
            Caption = 'Remaning Open Provision';
        }
        field(13; "Provision Reverse"; Boolean)
        {
            Caption = 'Provision Reverse';
        }
        field(14; "Reversal Document No"; Code[20])
        {
            Caption = 'Reversal Document No';
        }
        field(15; Isdocinsert; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Item Ledger Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Transporter Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Transporter Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Receipt No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
