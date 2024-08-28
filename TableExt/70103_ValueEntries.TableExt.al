tableextension 70103 VLEKPMG extends "Value Entry"
{
    fields
    {
        field(70100; "Charge(Item) Type KPMG"; Option)
        {
            FieldClass = FlowField;
            OptionMembers = " ",Provisional;
            OptionCaption = ' ,Provisional';
            Caption = 'Charge(Item) Type';
            CalcFormula = lookup("Purch. Inv. Header"."Charge Item Type KPMG" where("No." = field("Document No.")));
        }
        field(70101; "Charge(Item) Type KPMG CR"; Option)
        {
            FieldClass = FlowField;
            OptionMembers = " ",Provisional;
            OptionCaption = ' ,Provisional';
            Caption = 'Charge(Item) Type For Cr. Memo';
            CalcFormula = lookup("Purch. Cr. Memo Hdr."."Charge Item Type KPMG" where("No." = field("Document No.")));
        }
    }

    var
        myInt: Integer;
}