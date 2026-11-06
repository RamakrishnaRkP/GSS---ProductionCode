page 60173 OrderBookingAPI
{
    PageType = API;
    Caption = 'BookingReport';
    APIPublisher = 'GSS';
    APIGroup = 'BookingReport';
    APIVersion = 'v1.0';
    EntityName = 'BookingReport';
    EntitySetName = 'BookingReport';
    SourceTable = Job;
    SourceTableView = sorting("No.")order(ascending)where(GSSStatus=filter(Released|"Pending Approval"));
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(No_; Rec."No.")
                {
                }
                field(Creation_Date; Rec."Creation Date")
                {
                }
                field(Bill_to_Customer_No_; Rec."Bill-to Customer No.")
                {
                }
                field(Bill_to_Name; Rec."Bill-to Name")
                {
                }
                field(Bill_to_Name_2; Rec."Bill-to Name 2")
                {
                }
                field(GSSSalesperson_Code; Rec."GSSSalesperson Code")
                {
                }
                field(GSSTeam; Rec.GSSTeam)
                {
                }
                field(GSSStatus; Rec.GSSStatus)
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(SalesPersonName; SalesPersonRec.Name)
                {
                }
                field(InternalCost; InternalCost)
                {
                }
            }
        }
    }
    trigger OnInit()
    begin
    end;
    trigger OnAfterGetRecord()
    begin
        Clear(InternalCost);
        if SalesPersonRec.Get(Rec."GSSSalesperson Code")then;
        JPLRec.Reset();
        JPLRec.SetRange("Job No.", Rec."No.");
        if JPLRec.FindSet()then repeat JPLRec.CalcFields("GSSItem Type");
                JPLRec.CalcFields("GSSGlobal Dimension 1 Code");
                case JPLRec."No." of 'AMC-APL': InternalCost+=JPLRec."Total Cost";
                'AMC-DTS': InternalCost+=JPLRec."Total Cost";
                'AMC-ESS': InternalCost+=JPLRec."Total Cost";
                'AMC-NSS': InternalCost+=JPLRec."Total Cost";
                'PS-APL': InternalCost+=JPLRec."Total Cost";
                'PS-DTS': InternalCost+=JPLRec."Total Cost";
                'PS-ESS': InternalCost+=JPLRec."Total Cost";
                'PS-NSS': InternalCost+=JPLRec."Total Cost";
                end;
            until JPLRec.Next() = 0;
    end;
    var var InternalCost: Decimal;
    PlannedDeliveryMonth: Text;
    SalesPersonRec: Record "Salesperson/Purchaser";
    FilterText: Text;
    CompInfo: Record "Company Information";
    HideTotals: Boolean;
    HideHeader: Boolean;
    GroupByLOB: Boolean;
    GroupBySubLOB: Boolean;
    ShowItemDetails: Boolean;
    IncludeGL: Boolean;
    BillablePrice: Decimal;
    SUBLOB: Code[20];
    ItemRec: Record Item;
    UserSetup: Record "User Setup";
    JPLRec: Record "Job Planning Line";
}
