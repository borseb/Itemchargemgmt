page 70100 "Slab Rates of Port"
{
    ApplicationArea = Administration;
    Caption = 'Slab Rates of Port';
    DelayedInsert = true;
    PageType = List;
    SourceTable = SlabRateKPMG;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Parent Location code"; Rec."Parent Location code")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("0-30Days"; Rec."0-30Days")
                {
                    ApplicationArea = All;
                }
                field("31-60Days"; Rec."31-60Days")
                {
                    ApplicationArea = All;
                }
                field("61-90Days"; Rec."61-90Days")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}

