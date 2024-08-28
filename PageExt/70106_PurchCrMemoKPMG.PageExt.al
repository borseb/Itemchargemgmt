pageextension 70106 PurchCrMemo extends "Purchase Credit Memo"
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
}