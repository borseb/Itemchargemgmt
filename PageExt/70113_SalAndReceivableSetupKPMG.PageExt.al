pageextension 70113 SalAndRcvblSetupKPMG extends "Sales & Receivables Setup"
{
    layout
    {
        addlast("Background Posting")
        {
            field("Debit Note Account"; Rec."Debit Note Account")
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