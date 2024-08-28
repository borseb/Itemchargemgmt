table 70101 WarehouseCharges
{
    DataClassification = ToBeClassified;

    fields
    {
        field(70100; "Parent Location code"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Parent Location Code';

        }
        field(70101; "Item Category Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Item Category";
            Caption = 'Item Category code';
        }
        field(70102; "Charge per month"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Charge per month';
        }
    }

    keys
    {
        key(Key1; "Parent Location code", "Item Category Code")
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