pageextension 70119 GenPostingSetupExt extends "General Posting Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("Vendor No"; Rec."Vendor No")
            {
                ApplicationArea = All;
            }
            field("Provision for Purchase Acc."; Rec."Provision for Purchase Acc.")
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