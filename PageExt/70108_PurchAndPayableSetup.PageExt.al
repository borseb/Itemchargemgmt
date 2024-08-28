pageextension 70109 PurchAndPayableSetupKPMG extends "Purchases & Payables Setup"
{
    layout
    {
        addlast("Default Accounts")
        {
            field("Provisional Vendor No."; Rec."Provisional Vendor No.")
            {
                ApplicationArea = All;
            }
            field("Location Code KPMG"; Rec."Location Code KPMG")
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