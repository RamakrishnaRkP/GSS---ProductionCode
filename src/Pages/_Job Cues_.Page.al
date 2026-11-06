page 60190 "Job Cues"
{
    PageType = CardPart;
    Caption = 'Jobs';

    layout
    {
        area(content)
        {
            cuegroup(OutboxCueContainer)
            {
                Caption = 'Job Values';

                field("Sales This Month"; TotalMonthSales)
                {
                    ApplicationArea = All;
                    DecimalPlaces = 0: 0;
                    DrillDownPageID = "Sales Invoice List";
                    ToolTip = 'Specifies the sum of sales in the current year excluding taxes.';

                    trigger OnDrillDown()
                    begin
                        SalesthisMonth;
                    end;
                }
                field("Sales This Year"; TotalYearSales)
                {
                    ApplicationArea = All;
                    DecimalPlaces = 0: 0;
                    DrillDownPageID = "Sales Invoice List";
                    ToolTip = 'Specifies the sum of sales in the current year excluding taxes.';

                    trigger OnDrillDown()
                    begin
                        SalesthisYear;
                    end;
                }
                field("Bookings This Year"; AmountLCY)
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Sales Orders";
                    DecimalPlaces = 0: 0;
                    ToolTip = 'Specifies the sum of Orders Booked in the current year excluding taxes.';

                    trigger OnDrillDown()
                    begin
                        OrdersthisYear;
                    end;
                }
                field("Bookings This Month"; MonthAmountLCY)
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Sales Orders";
                    DecimalPlaces = 0: 0;
                    ToolTip = 'Specifies the sum of Orders Booked in the current year excluding taxes.';

                    trigger OnDrillDown()
                    begin
                        OrdersthisMonth;
                    end;
                }
                field(ActualGP; BillablePrice - BudgetedCost)
                {
                    ApplicationArea = All;
                    DecimalPlaces = 0: 0;

                    trigger OnDrillDown()
                    begin
                        JobListForGP;
                    end;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        //  Rec.SetRange(SalesThisYearFilter, CalcDate('<-CY>', LogInManagement.GetDefaultWorkDate()), LogInManagement.GetDefaultWorkDate());
        // Rec.SetRange(OrdersThisYearFilter, CalcDate('<-CY>', LogInManagement.GetDefaultWorkDate()), LogInManagement.GetDefaultWorkDate());
        if UserSetup.Get(UserId)then;
    end;
    trigger OnAfterGetCurrRecord()
    var
        // [SecurityFiltering(SecurityFilter::Filtered)]
        JobRec: Record Job;
        LogInManagement: Codeunit LogInManagement;
        CurrExchRate: Record "Currency Exchange Rate";
        // [SecurityFiltering(SecurityFilter::Validated)]
        CustLedgerEntry: Record "Cust. Ledger Entry";
        GLEntryRec: Record "G/L Entry";
        CurrRec: Record Currency;
        // [SecurityFiltering(SecurityFilter::Filtered)]
        JobMonthRec: Record Job;
    begin
        Clear(AmountLCY);
        Clear(TotalYearSales);
        Clear(TotalOverdueSalesInvoice);
        Clear(TotalMonthSales);
        Clear(MonthAmountLCY);
        JobRec.Reset();
        JobRec.SetFilter(GSSStatus, '<>%1', JobRec.GSSStatus::Open);
        if UserSetup."SalesPerson Filter" <> '' then JobRec.SetFilter("GSSSalesperson Code", UserSetup."SalesPerson Filter");
        JobRec.SetRange("Creation Date", CalcDate('<-CY>', LogInManagement.GetDefaultWorkDate()), LogInManagement.GetDefaultWorkDate());
        if JobRec.FindSet()then repeat /*  if ((JobRec."Invoice Currency Code" <> '') and (JobRec."GSSCustomer PO Amount" <> 0)) then begin
                     CurrRec.Get(JobRec."Invoice Currency Code");
                     AmountLCY += CurrExchRate.ExchangeAmtFCYToLCY(
                            JobRec."Creation Date", JobRec."Invoice Currency Code", JobRec."GSSCustomer PO Amount", CurrRec."Currency Factor");
                 end else begin */
                AmountLCY+=JobRec."GSSCustomer PO Amount";
            // end;
            until JobRec.Next() = 0;
        JobMonthRec.Reset();
        JobMonthRec.SetFilter(GSSStatus, '<>%1', JobMonthRec.GSSStatus::Open);
        if UserSetup."SalesPerson Filter" <> '' then JobMonthRec.SetFilter("GSSSalesperson Code", UserSetup."SalesPerson Filter");
        JobMonthRec.SetRange("Creation Date", CalcDate('<-CM>', LogInManagement.GetDefaultWorkDate()), LogInManagement.GetDefaultWorkDate());
        if JobMonthRec.FindSet()then repeat /* if ((JobMonthRec."Invoice Currency Code" <> '') and (JobMonthRec."GSSCustomer PO Amount" <> 0)) then begin
                    CurrRec.Get(JobMonthRec."Invoice Currency Code");
                    MonthAmountLCY += CurrExchRate.ExchangeAmtFCYToLCY(
                           JobMonthRec."Creation Date", JobMonthRec."Invoice Currency Code", JobMonthRec."GSSCustomer PO Amount", CurrRec."Currency Factor");
                end else begin */
                MonthAmountLCY+=JobMonthRec."GSSCustomer PO Amount";
            //end;
            until JobMonthRec.Next() = 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetFilter("Document Type", '%1|%2', CustLedgerEntry."Document Type"::Invoice, CustLedgerEntry."Document Type"::"Credit Memo");
        if UserSetup."SalesPerson Filter" <> '' then CustLedgerEntry.Setfilter("Salesperson Code", UserSetup."SalesPerson Filter");
        CustLedgerEntry.SetRange("Posting Date", CalcDate('<-CY>', LogInManagement.GetDefaultWorkDate()), LogInManagement.GetDefaultWorkDate());
        if CustLedgerEntry.FindSet()then repeat TotalYearSales+=CustLedgerEntry."Sales (LCY)";
            until CustLedgerEntry.Next() = 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetFilter("Document Type", '%1|%2', CustLedgerEntry."Document Type"::Invoice, CustLedgerEntry."Document Type"::"Credit Memo");
        if UserSetup."SalesPerson Filter" <> '' then CustLedgerEntry.Setfilter("Salesperson Code", UserSetup."SalesPerson Filter");
        CustLedgerEntry.SetRange("Posting Date", CalcDate('<-CM>', LogInManagement.GetDefaultWorkDate()), LogInManagement.GetDefaultWorkDate());
        if CustLedgerEntry.FindSet()then repeat TotalMonthSales+=CustLedgerEntry."Sales (LCY)";
            until CustLedgerEntry.Next() = 0;
        Clear(BillablePrice);
        Clear(InternalCost);
        Clear(BudgetedCost);
        CalculateAccount();
        GlobalJobRec.Reset();
        if UserSetup."SalesPerson Filter" <> '' then GlobalJobRec.Setfilter("GSSSalesperson Code", UserSetup."SalesPerson Filter");
        GlobalJobRec.SetRange("Creation Date", CalcDate('<-CM>', LogInManagement.GetDefaultWorkDate()), LogInManagement.GetDefaultWorkDate());
        GlobalJobRec.SetFilter(GSSStatus, '%1|%2', GlobalJobRec.GSSStatus::"Pending Approval", GlobalJobRec.GSSStatus::Released);
        if GlobalJobRec.FindSet()then repeat GLRec.SetRange("Job No.", GlobalJobRec."No.");
                if GLRec.FindSet()then repeat if AccountExists(RevenueAccs, GLRec."G/L Account No.")then BillablePrice+=(GLRec.Amount * -1);
                        if AccountExists(InternalCostAccs, GLRec."G/L Account No.")then InternalCost+=GLRec.Amount;
                        if AccountExists(CostOfSalesAccs, GLRec."G/L Account No.")then BudgetedCost+=GLRec.Amount;
                    until GLRec.Next() = 0;
            until GlobalJobRec.Next() = 0;
    end;
    local procedure SalesthisYear()
    var
        //  [SecurityFiltering(SecurityFilter::Validated)]
        CustLedgerEntry: Record "Cust. Ledger Entry";
        LogInManagement: Codeunit LogInManagement;
    begin
        CustLedgerEntry.SetFilter("Document Type", '%1|%2', CustLedgerEntry."Document Type"::Invoice, CustLedgerEntry."Document Type"::"Credit Memo");
        if UserSetup."SalesPerson Filter" <> '' then CustLedgerEntry.Setfilter("Salesperson Code", UserSetup."SalesPerson Filter");
        CustLedgerEntry.SetRange("Posting Date", CalcDate('<-CY>', LogInManagement.GetDefaultWorkDate()), LogInManagement.GetDefaultWorkDate());
        PAGE.Run(PAGE::"Customer Ledger Entries", CustLedgerEntry);
    end;
    local procedure SalesthisMonth()
    var
        //  [SecurityFiltering(SecurityFilter::Validated)]
        CustLedgerEntry: Record "Cust. Ledger Entry";
        LogInManagement: Codeunit LogInManagement;
    begin
        CustLedgerEntry.SetFilter("Document Type", '%1|%2', CustLedgerEntry."Document Type"::Invoice, CustLedgerEntry."Document Type"::"Credit Memo");
        if UserSetup."SalesPerson Filter" <> '' then CustLedgerEntry.Setfilter("Salesperson Code", UserSetup."SalesPerson Filter");
        CustLedgerEntry.SetRange("Posting Date", CalcDate('<-CM>', LogInManagement.GetDefaultWorkDate()), LogInManagement.GetDefaultWorkDate());
        PAGE.Run(PAGE::"Customer Ledger Entries", CustLedgerEntry);
    end;
    local procedure OrdersthisMonth()
    var
        // [SecurityFiltering(SecurityFilter::Filtered)]
        JobRec: Record Job;
        LogInManagement: Codeunit LogInManagement;
    begin
        JobRec.Reset();
        JobRec.SetFilter(GSSStatus, '<>%1', JobRec.GSSStatus::Open);
        if UserSetup."SalesPerson Filter" <> '' then JobRec.Setfilter("GSSSalesperson Code", UserSetup."SalesPerson Filter");
        JobRec.SetRange("Creation Date", CalcDate('<-CM>', LogInManagement.GetDefaultWorkDate()), LogInManagement.GetDefaultWorkDate());
        PAGE.Run(PAGE::"Job List", JobRec);
    end;
    local procedure JobListForGP()
    var
        // [SecurityFiltering(SecurityFilter::Filtered)]
        JobRec: Record Job;
        LogInManagement: Codeunit LogInManagement;
    begin
        JobRec.Reset();
        JobRec.SetFilter(GSSStatus, '<>%1', JobRec.GSSStatus::Open);
        JobRec.SetRange("Creation Date", CalcDate('<-CM>', LogInManagement.GetDefaultWorkDate()), LogInManagement.GetDefaultWorkDate());
        if UserSetup."SalesPerson Filter" <> '' then JobRec.SetFilter("GSSSalesperson Code", UserSetup."SalesPerson Filter");
        //JobRec.SetRange("Creation Date", CalcDate('<-CM>', LogInManagement.GetDefaultWorkDate()), LogInManagement.GetDefaultWorkDate());
        PAGE.Run(PAGE::"Job List", JobRec);
    end;
    local procedure OrdersthisYear()
    var
        //  [SecurityFiltering(SecurityFilter::Filtered)]
        JobRec: Record Job;
        LogInManagement: Codeunit LogInManagement;
    begin
        JobRec.Reset();
        JobRec.SetFilter(GSSStatus, '<>%1', JobRec.GSSStatus::Open);
        if UserSetup."SalesPerson Filter" <> '' then JobRec.Setfilter("GSSSalesperson Code", UserSetup."SalesPerson Filter");
        JobRec.SetRange("Creation Date", CalcDate('<-CY>', LogInManagement.GetDefaultWorkDate()), LogInManagement.GetDefaultWorkDate());
        PAGE.Run(PAGE::"Job List", JobRec);
    end;
    local procedure CalculateAccount()
    begin
        InvAccSchedule:='JOBINVREP';
        if AccSchedule.Get(InvAccSchedule)then begin
            AccScheduleLines.SetCurrentKey("Schedule Name", "Line No.");
            AccScheduleLines.SetRange("Schedule Name", AccSchedule.Name);
            AccScheduleLines.SetRange(Description, 'Revenue');
            if AccScheduleLines.FindFirst()then RevenueAccStart:=AccScheduleLines."Row No.";
            AccScheduleLines.SetRange(Description, 'Revenue Total');
            if AccScheduleLines.FindFirst()then RevenueAccEnd:=AccScheduleLines."Row No.";
            AccScheduleLines.SetRange(Description, 'Cost of Sales');
            if AccScheduleLines.FindFirst()then CostOfSalesAccStart:=AccScheduleLines."Row No.";
            AccScheduleLines.SetRange(Description, 'Cost of Sales Total');
            if AccScheduleLines.FindFirst()then CostOfSalesAccEnd:=AccScheduleLines."Row No.";
            AccScheduleLines.SetRange(Description, 'Internal Cost');
            if AccScheduleLines.FindFirst()then InternalCostAccStart:=AccScheduleLines."Row No.";
            AccScheduleLines.SetRange(Description, 'Internal Cost Total');
            if AccScheduleLines.FindFirst()then InternalCostAccEnd:=AccScheduleLines."Row No.";
            I:=1;
            AccScheduleLines.SetRange(Description);
            AccScheduleLines.SetRange("Row No.", RevenueAccStart, RevenueAccEnd);
            AccScheduleLines.SetFilter(Totaling, '<>%1', '');
            if AccScheduleLines.FindFirst()then repeat RevenueAccs[I]:=AccScheduleLines.Totaling;
                    I+=1;
                until AccScheduleLines.Next() = 0;
            I:=1;
            AccScheduleLines.SetRange(Description);
            AccScheduleLines.SetRange("Row No.", CostOfSalesAccStart, CostOfSalesAccEnd);
            AccScheduleLines.SetFilter(Totaling, '<>%1', '');
            if AccScheduleLines.FindFirst()then repeat CostOfSalesAccs[I]:=AccScheduleLines.Totaling;
                    I+=1;
                until AccScheduleLines.Next() = 0;
            I:=1;
            AccScheduleLines.SetRange(Description);
            AccScheduleLines.SetRange("Row No.", InternalCostAccStart, InternalCostAccEnd);
            AccScheduleLines.SetFilter(Totaling, '<>%1', '');
            if AccScheduleLines.FindFirst()then repeat InternalCostAccs[I]:=AccScheduleLines.Totaling;
                    I+=1;
                until AccScheduleLines.Next() = 0;
        end;
    end;
    local procedure AccountExists(Arr: Array[50]of code[20]; AccNo: Code[20]): Boolean var
        Exists: Boolean;
    begin
        Exists:=false;
        if ArrayLen(Arr) = 0 then exit(Exists);
        for I:=1 to ArrayLen(Arr)do begin
            if Arr[I] = AccNo then begin
                Exists:=true;
                break;
            end;
        end;
        Exit(Exists);
    end;
    var AmountLCY: Decimal;
    MonthAmountLCY: Decimal;
    LogInManagement: Codeunit LogInManagement;
    TotalYearSales: Decimal;
    TotalMonthSales: Decimal;
    TotalOverdueSalesInvoice: Decimal;
    TotalOverduePurchaceInvoice: Decimal;
    UserSetup: Record "User Setup";
    I: Integer;
    InvAccSchedule: Code[20];
    AccSchedule: Record "Acc. Schedule Name";
    AccScheduleLines: Record "Acc. Schedule Line";
    RevenueAccs: array[50]of Code[20];
    CostOfSalesAccs: array[50]of Code[20];
    InternalCostAccs: array[50]of Code[20];
    RevenueAccStart: Text;
    RevenueAccEnd: Text;
    CostOfSalesAccStart: Text;
    CostOfSalesAccEnd: Text;
    InternalCostAccStart: Text;
    InternalCostAccEnd: Text;
    //  [SecurityFiltering(SecurityFilter::Filtered)]
    GlobalJobRec: Record Job;
    GLRec: Record "G/L Entry";
    BillablePrice: Decimal;
    BudgetedCost: Decimal;
    InternalCost: Decimal;
}
