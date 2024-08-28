page 70105 LocationsAPI
{
    PageType = API;
    Caption = 'locationsAPI';
    APIPublisher = 'kpmg';
    APIGroup = 'kpmg';
    APIVersion = 'v2.0';
    EntityName = 'locationsAPI';
    EntitySetName = 'locationsAPI';
    SourceTable = Location;
    DelayedInsert = true;
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(AddressLine1; Rec.Address)
                {
                    ApplicationArea = All;
                }
                field("AddressLine2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                }
                field(Contact; Rec.Contact)
                {
                    ApplicationArea = All;
                }
                field("CountryRegionCode"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("EMail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                }
                field(SystemId; Rec.SystemId)
                {
                    ApplicationArea = All;
                }
                field("PhoneNo"; Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
                field("StateCode"; Rec."State Code")
                {
                    ApplicationArea = All;
                }
                field("PostCode"; Rec."Post Code")
                {
                    ApplicationArea = All;
                }
                field("LocationTypeKPMG"; Rec."Location Type KPMG")
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}