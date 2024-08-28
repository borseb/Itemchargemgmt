pageextension 70104 ValueEntryKPMG extends "Value Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("Charge(Item) Type KPMG"; Rec."Charge(Item) Type KPMG")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Charge(Item) Type KPMG CR"; Rec."Charge(Item) Type KPMG CR")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}