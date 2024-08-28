pageextension 70112 usersetupkpmg extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field("Trade Member"; Rec."Trade Member")
            {
                ApplicationArea = All;
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