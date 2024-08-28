pageextension 70117 InvPostingSetup_KPMG extends "Inventory Posting Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Inventory Account")
        {
            field("Provision Inventory"; Rec."Provision Inventory")
            {
                ApplicationArea = all;
            }
            field("Provision Inventory (Interim)"; Rec."Provision Inventory (Interim)")
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