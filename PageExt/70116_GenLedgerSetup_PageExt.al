pageextension 70116 GenLedgerseupExt_KPMG extends "General Ledger Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("LCY Code")
        {
            field("Provision for Purchase Acc."; Rec."Provision for Purchase Acc.")
            {
                ApplicationArea = all;
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