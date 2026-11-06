report 60113 "GSSOrder Backlog Report"
{
    ApplicationArea = All;
    Caption = 'Order Backlog Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/GSSOrderBacklogReport.rdl';

    dataset
    {
        dataitem(Job; Job)
        {
            DataItemTableView = sorting("No.")order(ascending)where(GSSStatus=filter(Released|"Pending Approval"), Status=filter(<>Completed));
            RequestFilterFields = "No.", "GSSSalesperson Code", GSSTeam, "Bill-to Customer No.", "Creation Date";
            PrintOnlyIfDetail = true;

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
            column(FinanceUser; UserSetup."Finance User")
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
                column(GSSTotal_Billable_Price; BillablePrice)
                {
                }
                column(GSSTotal_Budgeted_Cost; BudgetedCost)
                {
                }
                column(GSSGross_Margin; GrossProfit)
                {
                }
                column(GM_Without_IntCost; GrossProfitWoInternalCost)
                {
                }
                column(PlannedDeliveryMonth; UpperCase(PlannedDeliveryMonth))
                {
                }
                column(PlannedDeliveryMonthNumber; PlannedDeliveryMonthNumber)
                {
                }
                column(SUBLOB; SUBLOB)
                {
                }
                column(VendorName; ItemRec."Manufacturer Code")
                {
                }
                trigger OnAfterGetRecord()
                begin
                    Clear(InternalCost);
                    Clear(BillablePrice);
                    Clear(BudgetedCost);
                    Clear(GrossProfit);
                    Clear(GrossProfitWoInternalCost);
                    Clear(PlannedDeliveryMonth);
                    Clear(PlannedDeliveryMonthNumber);
                    Clear(SUBLOB);
                    "Job Planning Line".CalcFields("GSSGlobal Dimension 1 Code");
                    if "Job Planning Line"."GSSGlobal Dimension 1 Code" <> '' then begin
                        if ItemRec.Get("Job Planning Line"."No.")then SUBLOB:=ItemRec."Global Dimension 2 Code";
                    end;
                    "Job Planning Line".CalcFields("GSSItem Type");
                    if "Job Planning Line".Type = "Job Planning Line".Type::Item then begin
                        //  if "Job Planning Line"."GSSItem Type" = "Job Planning Line"."GSSItem Type"::"Non-Inventory" then
                        //  if "Job Planning Line"."No." <> 'MS-ESS' then
                        case "Job Planning Line"."No." of 'AMC-APL': InternalCost:="Job Planning Line"."Unit Cost" * "Job Planning Line"."Remaining Qty.";
                        'AMC-DTS': InternalCost:="Job Planning Line"."Unit Cost" * "Job Planning Line"."Remaining Qty.";
                        'AMC-ESS': InternalCost:="Job Planning Line"."Unit Cost" * "Job Planning Line"."Remaining Qty.";
                        'AMC-NSS': InternalCost:="Job Planning Line"."Unit Cost" * "Job Planning Line"."Remaining Qty.";
                        'PS-APL': InternalCost:="Job Planning Line"."Unit Cost" * "Job Planning Line"."Remaining Qty.";
                        'PS-DTS': InternalCost:="Job Planning Line"."Unit Cost" * "Job Planning Line"."Remaining Qty.";
                        'PS-ESS': InternalCost:="Job Planning Line"."Unit Cost" * "Job Planning Line"."Remaining Qty.";
                        'PS-NSS': InternalCost:="Job Planning Line"."Unit Cost" * "Job Planning Line"."Remaining Qty.";
                        end;
                    end;
                    BillablePrice:="Job Planning Line"."Remaining Qty." * "Job Planning Line"."Unit Price";
                    BudgetedCost:="Job Planning Line"."Remaining Qty." * "Job Planning Line"."Unit Cost";
                    GrossProfit:=BillablePrice - BudgetedCost;
                    GrossProfitWoInternalCost:=GrossProfit + InternalCost;
                    PlannedDeliveryMonth:=Format("Job Planning Line"."Planned Delivery Date", 0, '<Month Text,3>-<Year4>');
                    PlannedDeliveryMonthNumber:=Format("Job Planning Line"."Planned Delivery Date", 0, '<Month,2>-<Year4>');
                    if(InternalCost = 0) and (BillablePrice = 0) and (BudgetedCost = 0) and (GrossProfit = 0) and (GrossProfitWoInternalCost = 0)then CurrReport.Skip();
                end;
            }
            trigger OnAfterGetRecord()
            begin
                Clear(SalesPersonRec);
                Clear(InternalCost);
                Clear(BillablePrice);
                Clear(BudgetedCost);
                Clear(GrossProfit);
                Clear(GrossProfitWoInternalCost);
                Clear(PlannedDeliveryMonth);
                Clear(PlannedDeliveryMonthNumber);
                if SalesPersonRec.Get("GSSSalesperson Code")then;
            end;
            trigger OnPreDataItem()
            begin
                if UserSetup.Get(UserId)then;
                if UserSetup."SalesPerson Filter" <> '' then Job.Setfilter("GSSSalesperson Code", UserSetup."SalesPerson Filter");
            end;
        }
    }
    requestpage
    {
        SaveValues = true;

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
    end;
    var PlannedDeliveryMonth: Text;
    //Used for report sorting purposes.
    PlannedDeliveryMonthNumber: Text;
    SalesPersonRec: Record "Salesperson/Purchaser";
    FilterText: Text;
    CompInfo: Record "Company Information";
    HideTotals: Boolean;
    HideHeader: Boolean;
    GroupByLOB: Boolean;
    GroupBySubLOB: Boolean;
    BillablePrice: Decimal;
    BudgetedCost: Decimal;
    InternalCost: Decimal;
    GrossProfit: Decimal;
    GrossProfitWoInternalCost: Decimal;
    SUBLOB: Code[20];
    ItemRec: Record Item;
    UserSetup: Record "User Setup";
}
