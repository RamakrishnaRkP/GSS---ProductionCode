report 60173 "GSSOrder Booking Report2"
{
    // ApplicationArea = All;
    Caption = 'Order Booking Report';
    //UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/GSSOrderBookingReport.rdl';

    dataset
    {
        dataitem(Job; Job)
        {
            DataItemTableView = sorting("No.")order(ascending)where(GSSStatus=filter(Released|"Pending Approval"));
            RequestFilterFields = "No.", "GSSSalesperson Code", GSSTeam, "Bill-to Customer No.", "Creation Date";

            column(No_; "No.")
            {
            }
            column(Creation_Date; "Creation Date")
            {
            }
            column(Bill_to_Customer_No_; "Bill-to Customer No.")
            {
            }
            column(Bill_to_Name; "Bill-to Name")
            {
            }
            column(Bill_to_Name_2; "Bill-to Name 2")
            {
            }
            column(GSSSalesperson_Code; "GSSSalesperson Code")
            {
            }
            column(GSSTeam; GSSTeam)
            {
            }
            column(GSSStatus; GSSStatus)
            {
            }
            column(Status; Status)
            {
            }
            column(PlannedDeliveryMonth; PlannedDeliveryMonth)
            {
            }
            column(SalesPersonName; SalesPersonRec.Name)
            {
            }
            column(FilterText; FilterText)
            {
            }
            column(CompName; CompInfo.Name)
            {
            }
            column(CompLogo; CompInfo.Picture)
            {
            }
            column(HideTotals; HideTotals)
            {
            }
            column(GroupByLOB; GroupByLOB)
            {
            }
            column(GroupBySubLOB; GroupBySubLOB)
            {
            }
            column(ShowItemDetails; ShowItemDetails)
            {
            }
            column(IncludeGL; IncludeGL)
            {
            }
            dataitem("Job Planning Line"; "Job Planning Line")
            {
                DataItemLink = "Job No."=field("No.");
                DataItemTableView = sorting("Job No.", "Job Task No.", "Line No.")order(ascending)where("Line Type"=filter(Budget|"Both Budget and Billable"));

                column(GSSGlobal_Dimension_1_Code; "GSSGlobal Dimension 1 Code")
                {
                }
                column(GSSGlobal_Dimension_2_Code; "GSSGlobal Dimension 2 Code")
                {
                }
                column(InternalCost; InternalCost)
                {
                }
                column(GSSTotal_Billable_Price; "Job Planning Line"."Total Price")
                {
                }
                column(GSSTotal_Budgeted_Cost; "Job Planning Line"."Total Cost")
                {
                }
                column(GSSGross_Margin;("Total Price" - "Total Cost"))
                {
                }
                column(GM_Without_IntCost;("Total Price" - ("Total Cost" - InternalCost)))
                {
                }
                column(SUBLOB; SUBLOB)
                {
                }
                column(ItemNo; "No.")
                {
                }
                column(Type; Type)
                {
                }
                column(Planned_Delivery_Date; Format("Planned Delivery Date"))
                {
                }
                column(VendorName; ItemRec."Manufacturer Code")
                {
                }
                column(Description; Description)
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(GSSSupply_From; "GSSSupply From")
                {
                }
                column(GSSSupply_From_Name; "GSSSupply From Name")
                {
                }
                trigger OnAfterGetRecord()
                begin
                    Clear(InternalCost);
                    Clear(BillablePrice);
                    Clear(SUBLOB);
                    if not IncludeGL then "Job Planning Line".SetRange(Type, "Job Planning Line".Type::Item);
                    "Job Planning Line".CalcFields("GSSGlobal Dimension 1 Code");
                    if "Job Planning Line"."GSSGlobal Dimension 1 Code" <> '' then begin
                        if ItemRec.Get("Job Planning Line"."No.")then SUBLOB:=ItemRec."Global Dimension 2 Code";
                    end;
                    "Job Planning Line".CalcFields("GSSItem Type");
                    if "Job Planning Line".Type = "Job Planning Line".Type::Item then begin
                        case "Job Planning Line"."No." of 'AMC-APL': InternalCost:="Job Planning Line"."Total Cost";
                        'AMC-DTS': InternalCost:="Job Planning Line"."Total Cost";
                        'AMC-ESS': InternalCost:="Job Planning Line"."Total Cost";
                        'AMC-NSS': InternalCost:="Job Planning Line"."Total Cost";
                        'PS-APL': InternalCost:="Job Planning Line"."Total Cost";
                        'PS-DTS': InternalCost:="Job Planning Line"."Total Cost";
                        'PS-ESS': InternalCost:="Job Planning Line"."Total Cost";
                        'PS-NSS': InternalCost:="Job Planning Line"."Total Cost";
                        end;
                    end;
                end;
                trigger OnPreDataItem()
                begin
                    HideTotals:=true;
                    GroupByLOB:=true;
                    //GroupBySubLOB := true;
                    if not IncludeGL then "Job Planning Line".SetRange(Type, "Job Planning Line".Type::Item);
                end;
            }
            trigger OnAfterGetRecord()
            begin
                Clear(SalesPersonRec);
                if SalesPersonRec.Get("GSSSalesperson Code")then;
            end;
            trigger OnPreDataItem()
            begin
                HideTotals:=true;
                GroupByLOB:=true;
                // GroupBySubLOB := true;
                if UserSetup.Get(UserId)then;
                if UserSetup."SalesPerson Filter" <> '' then Job.SetFilter("GSSSalesperson Code", UserSetup."SalesPerson Filter");
            end;
        }
    }
    requestpage
    {
        // SaveValues = true;
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(HideTotals; HideTotals)
                    {
                        Caption = 'Hide Totals';
                        ApplicationArea = All;
                    }
                    field(GroupByLOB; GroupByLOB)
                    {
                        Caption = 'Group By LOB';
                        ApplicationArea = All;
                    }
                    field(GroupBySubLOB; GroupBySubLOB)
                    {
                        Caption = 'Group By SUB LOB';
                        ApplicationArea = All;
                    }
                    field(ShowItemDetails; ShowItemDetails)
                    {
                        Caption = 'Show Item Details';
                        ApplicationArea = All;
                    }
                    field(IncludeGL; IncludeGL)
                    {
                        Caption = 'Include GL';
                        ApplicationArea = all;
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    trigger OnPreReport()
    begin
        CompInfo.Get;
        CompInfo.CalcFields(Picture);
        FilterText:=Job.GetFilters;
        HideTotals:=true;
        GroupByLOB:=true;
    // GroupBySubLOB := true;
    end;
    procedure SetRequestParam(HideTot: Boolean; LOBGroup: Boolean)
    begin
        HideTotals:=HideTot;
        LOBGroup:=GroupByLOB;
    end;
    var InternalCost: Decimal;
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
}
