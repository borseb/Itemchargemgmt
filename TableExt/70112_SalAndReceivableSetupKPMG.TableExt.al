tableextension 70112 SalAndReceivSetup extends "Sales & Receivables Setup"
{
    fields
    {
        field(70100; "Debit Note Account"; Code[50])
        {
            Caption = 'Debit Note Account No.';
            TableRelation = "G/L Account"."No.";
        }
    }

    var
        myInt: Integer;
}