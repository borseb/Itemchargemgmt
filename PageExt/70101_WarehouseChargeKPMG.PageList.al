page 70101 WarehouseCharges
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = WarehouseCharges;
    Caption = 'Warehouse Charges';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                ShowCaption = false;
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                }
                field("Charge per month"; Rec."Charge per month")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}