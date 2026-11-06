pageextension 60178 SalesQuote extends "Sales Quote"
{
    layout
    {
        addafter("Salesperson Code")
        {
            field(GSSTeam; Rec.GSSTeam)
            {
                ApplicationArea = all;
            }
        }
        addafter(Status)
        {
            field("GSSGross Margin %"; Rec."GSSGross Margin %")
            {
                ApplicationArea = all;
            }
            field("GSSGross Margin"; Rec."GSSGross Margin")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addafter(SendApprovalRequest)
        {
            // action(CalculateGrossMargin)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Calculate Gross Margin';
            //     Image = CalculateCost;
            //     // Visible = false;
            //     Promoted = true;
            //     PromotedCategory = Category7;
            //     trigger OnAction()
            //     var
            //         QtyType: Option General,Invoicing,Shipping;
            //         SalesLine: Record "Sales Line";
            //         TempSalesLine: Record "Sales Line" temporary;
            //         TempVATAmountLine1: Record "VAT Amount Line" temporary;
            //         TotalSalesLineLCY: Record "Sales Line";
            //         TotalSalesLine: Record "Sales Line";
            //         SalesPost: Codeunit "Sales-Post";
            //         OrigProfitLCY: Decimal;
            //         OrigProfitPct: Decimal;
            //         AdjProfitLCY: Decimal;
            //         AdjProfitPct: Decimal;
            //         TotalOrigCostLCY: Decimal;
            //         TotalAdjCostLCY: Decimal;

            //         VATAmount: Decimal;
            //         VATAmountText: Text[30];
            //     begin
            //         Clear(VATAmount);
            //         Clear(OrigProfitLCY);
            //         Clear(OrigProfitPct);
            //         Clear(AdjProfitLCY);
            //         Clear(AdjProfitPct);
            //         Clear(TotalOrigCostLCY);
            //         Clear(TotalAdjCostLCY);
            //         Clear(TempVATAmountLine1);
            //         TempSalesLine.DeleteAll();
            //         Clear(TempSalesLine);
            //         Clear(SalesPost);
            //         SalesPost.GetSalesLines(Rec, TempSalesLine, 0);
            //         SalesLine.CalcVATAmountLines(0, Rec, TempSalesLine, TempVATAmountLine1);
            //         SalesPost.SumSalesLinesTemp(
            //                       Rec, TempSalesLine, 0, TotalSalesLine, TotalSalesLineLCY,
            //                       VATAmount, VATAmountText, OrigProfitLCY, OrigProfitPct, TotalAdjCostLCY, false);
            //         TotalOrigCostLCY := (TotalSalesLineLCY."Unit Cost (LCY)" / 2);
            //         AdjProfitLCY := (TotalSalesLineLCY.Amount / 2) - TotalAdjCostLCY;
            //         AdjProfitPct := Round(AdjProfitLCY / (TotalSalesLineLCY.Amount / 2) * 100, 0.1);
            //         Rec."GSSGross Margin" := OrigProfitLCY / 2;
            //         //  Rec."Adjusted Profit" := AdjProfitLCY;
            //         Rec."GSSGross Margin %" := OrigProfitPct;
            //         //Rec."Adjusted Profit %" := AdjProfitPct;
            //         Rec.Modify();
            //     end;
            // }
            action(CalculateGrossMargin)
            {
                ApplicationArea = All;
                Caption = 'Calculate Gross Margin';
                Image = CalculateCost;
                // Visible = false;
                Promoted = true;
                PromotedCategory = Category7;
                trigger OnAction()
                var
                    QtyType: Option General,Invoicing,Shipping;
                    SalesLine: Record "Sales Line";
                    TempSalesLine: Record "Sales Line" temporary;
                    TempVATAmountLine1: Record "VAT Amount Line" temporary;
                    SalesPost: Codeunit "Sales-Post";
                    OrigProfitLCY: Decimal;
                    OrigProfitPct: Decimal;
                    TotalCostLCY: Decimal;
                    TotalAmountLCY: Decimal;
                    TotalSalesLineLCY: Record "Sales Line";
                    TotalSalesLine: Record "Sales Line";
                    AdjProfitLCY: Decimal;
                    AdjProfitPct: Decimal;
                    VATAmount: Decimal;
                    VATAmountText: Text[30];
                    TotalAdjCostLCY: Decimal;

                begin
                    CalculateGrossMargin();
                end;
            }
        }
    }
    trigger OnDeleteRecord(): Boolean
    var
        myInt: Integer;
    begin
        CalculateGrossMargin()
    end;

    var
        myInt: Integer;


    local procedure CalculateGrossMargin()
    var
        QtyType: Option General,Invoicing,Shipping;
        SalesLine: Record "Sales Line";
        TempSalesLine: Record "Sales Line" temporary;
        TempVATAmountLine1: Record "VAT Amount Line" temporary;
        SalesPost: Codeunit "Sales-Post";
        OrigProfitLCY: Decimal;
        OrigProfitPct: Decimal;
        TotalCostLCY: Decimal;
        TotalAmountLCY: Decimal;
        TotalSalesLineLCY: Record "Sales Line";
        TotalSalesLine: Record "Sales Line";
        AdjProfitLCY: Decimal;
        AdjProfitPct: Decimal;
        VATAmount: Decimal;
        VATAmountText: Text[30];
        TotalAdjCostLCY: Decimal;

        TotalOrigCostLCY: Decimal;


    begin
        Clear(VATAmount);
        Clear(OrigProfitLCY);
        Clear(OrigProfitPct);
        Clear(TotalCostLCY);
        Clear(TotalAmountLCY);
        Clear(TempVATAmountLine1);
        TempSalesLine.Reset();
        TempSalesLine.DeleteAll();
        Clear(SalesPost);

        SalesPost.GetSalesLines(Rec, TempSalesLine, QtyType::General);
        SalesLine.CalcVATAmountLines(QtyType::General, Rec, TempSalesLine, TempVATAmountLine1);
        SalesPost.SumSalesLines(Rec, QtyType::General, TotalSalesLine, TotalSalesLineLCY,
                                                VATAmount, VATAmountText, OrigProfitLCY, OrigProfitPct, TotalAdjCostLCY);
        // TempSalesLine.Reset();
        // if TempSalesLine.FindSet() then
        //     repeat
        //         TotalAmountLCY += TempSalesLine.Amount;
        //         TotalCostLCY += TempSalesLine."Unit Cost (LCY)" * TempSalesLine.Quantity;
        //     // /TotalCostLCY += TempSalesLine."Unit Cost (LCY)";

        //     until TempSalesLine.Next() = 0;

        // OrigProfitLCY := Abs(TotalAmountLCY - TotalCostLCY);

        // if TotalAmountLCY <> 0 then
        //     OrigProfitPct := Round(OrigProfitLCY / TotalAmountLCY * 100, 0.1)
        // else
        //     OrigProfitPct := 0;

        Rec."GSSGross Margin" := OrigProfitLCY / 2;
        Rec."GSSGross Margin %" := OrigProfitPct;
        Rec.Modify();

    end;
}