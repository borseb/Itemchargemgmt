pageextension 70103 PurchInvKPMG extends "Purchase Invoice"
{
    layout
    {
        addlast(General)
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
        addafter("&Invoice")
        {
            action(SingleInstance)
            {
                Caption = 'Single Instance';
                ApplicationArea = All;
                Image = PostPrint;
                Promoted = true;
                RunObject = codeunit "Single Instance CU";

            }
        }
    }

    var
        myInt: Integer;
}