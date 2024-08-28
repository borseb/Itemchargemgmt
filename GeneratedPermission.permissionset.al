permissionset 70100 GeneratedPermission
{
    Assignable = true;
    Permissions = tabledata DebitNoteWorksheetKPMG=RIMD,
        tabledata SlabRateKPMG=RIMD,
        tabledata WarehouseCharges=RIMD,
        table DebitNoteWorksheetKPMG=X,
        table SlabRateKPMG=X,
        table WarehouseCharges=X,
        report MachineCost=X,
        codeunit ItemchargeInvoiceKPMG=X,
        codeunit ProcessLogicKPMG=X,
        codeunit "Single Instance CU"=X,
        page DebitNoteWorksheet=X,
        page LocationsAPI=X,
        page SalesShipmentAPI=X,
        page "Slab Rates of Port"=X,
        page SlabRatesOfPortKPMG=X,
        page WarehouseCharges=X,
        page WarehouseChargesAPI=X,
        query ItemChargeAssgnPurchKPMG=X,
        query SalesLine=X;
}