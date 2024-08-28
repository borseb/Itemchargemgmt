pageextension 70115 VendorCard_ExtKPMG extends "Vendor Card"
{
    layout
    {
        // Add changes to page layout here
        addafter(Address)
        {
            field("Charge Item Type KPMG"; Rec."Charge Item Type KPMG")
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