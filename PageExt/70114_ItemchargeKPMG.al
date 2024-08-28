pageextension 70114 ItemchargesforExt_KPMG extends "Item Charges"
{
    layout
    {
        // Add changes to page layout here
        addafter("HSN/SAC Code")
        {
            field("Vendor No"; Rec."Vendor No")
            {
                ApplicationArea = all;
            }
            field("Provision Direct Cost Applied"; Rec."Provision Direct Cost Applied")
            {
                ApplicationArea = All;
            }
            field("Provision Item Charge No."; Rec."Provision Item Charge No.")
            {
                ApplicationArea = All;
            }
            field(IsProvisionCharge; Rec.IsProvisionCharge)
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