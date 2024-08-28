page 70104 WarehouseChargesAPI
{
    PageType = API;
    Caption = 'warehouseCharges';
    APIPublisher = 'kpmg';
    APIGroup = 'kpmg';
    APIVersion = 'v2.0';
    EntityName = 'warehouseCharges';
    EntitySetName = 'warehouseCharges';
    SourceTable = WarehouseCharges;
    DelayedInsert = true;
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("ParentLocationcode"; Rec."Parent Location code")
                {
                    ApplicationArea = All;
                }
                field(SystemId; Rec.SystemId)
                {
                    ApplicationArea = All;
                }
                field("ItemCategoryCode"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                }
                field("Chargepermonth"; Rec."Charge per month")
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}