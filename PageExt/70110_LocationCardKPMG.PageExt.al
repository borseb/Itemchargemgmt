pageextension 70110 LocationMaster extends "Location Card"
{
    layout
    {
        addlast(General)
        {
            field("Location Type KPMG"; Rec."Location Type KPMG")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter("&Resource Locations")
        {
            action(SlabRates)
            {
                ApplicationArea = All;
                Caption = '&Slab Rates of Port';
                Image = Resource;
                RunObject = Page "Slab Rates of Port";
                RunPageLink = "Parent Location code" = FIELD(Code);
            }
            action(WarehouseCharges)
            {
                ApplicationArea = All;
                Caption = '&Warehouse Charges';
                Image = Resource;
                RunObject = Page WarehouseCharges;
                RunPageLink = "Parent Location code" = FIELD(Code);
            }

        }
    }

    var
        myInt: Integer;
}