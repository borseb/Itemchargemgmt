pageextension 70111 SalesOrderKPMG extends "Sales Order"
{
    layout
    {
        modify("Requested Delivery Date")
        {
            Caption = 'Promised Delivery Date';
        }
    }
}