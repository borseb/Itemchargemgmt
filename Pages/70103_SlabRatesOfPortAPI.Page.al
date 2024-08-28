page 70103 SlabRatesOfPortKPMG
{
    PageType = API;
    Caption = 'slabRatesOfPort';
    APIPublisher = 'kpmg';
    APIGroup = 'kpmg';
    APIVersion = 'v2.0';
    EntityName = 'slabRatesOfPort';
    EntitySetName = 'slabRatesOfPort';
    SourceTable = SlabRateKPMG;
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
                field("030Days"; Rec."0-30Days")
                {
                    ApplicationArea = All;
                }
                field("3160Days"; Rec."31-60Days")
                {
                    ApplicationArea = All;
                }
                field("6190Days"; Rec."61-90Days")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}