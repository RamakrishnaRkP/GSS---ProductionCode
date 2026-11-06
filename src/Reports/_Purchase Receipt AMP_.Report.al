report 60131 "Purchase Receipt AMP"
{
    Caption = 'Purchase Receipt';
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/PurchaseReceipt.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Buy-from Vendor No.", "No. Printed";
            RequestFilterHeading = 'Posted Purchase Receipt';

            column(No_PurchRcptHeader; "No.")
            {
            }
            column(Pay_to_Vendor_No_; "Pay-to Vendor No.")
            {
            }
            column(Vendor_Shipment_No_; "Vendor Shipment No.")
            {
            }
            column(SystemCreatedBy; UserRec."User Name")
            {
            }
            column(SalesOrderNo; "Order No.")
            {
            }
            column(PurchaseOrderNo; "Vendor Order No.")
            {
            }
            column(VAT_Registration_No_; "VAT Registration No.")
            {
            }
            column(CompAddress; CompanyInfo.Address + ' Phone No. : ' + CompanyInfo."Phone No.")
            {
            }
            column(CompTRN; CompanyInfo."VAT Registration No.")
            {
            }
            column(PurchaserName; SalesPurchPerson.Name)
            {
            }
            column(ShipToAddr1; ShipToAddr[1])
            {
            }
            column(CompanyAddr1; CompanyAddr[1])
            {
            }
            column(ShipToAddr2; ShipToAddr[2])
            {
            }
            column(CompanyAddr2; CompanyAddr[2])
            {
            }
            column(ShipToAddr3; ShipToAddr[3])
            {
            }
            column(CompanyAddr3; CompanyAddr[3])
            {
            }
            column(ShipToAddr4; ShipToAddr[4])
            {
            }
            column(CompanyAddr4; CompanyAddr[4])
            {
            }
            column(ShipToAddr5; ShipToAddr[5])
            {
            }
            column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(ShipToAddr6; ShipToAddr[6])
            {
            }
            column(CompanyInfoHomePage; CompanyInfo."Home Page")
            {
            }
            column(CompanyInfoEmail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
            {
            }
            column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
            {
            }
            column(CompanyInfoBankName; CompanyInfo."Bank Name")
            {
            }
            column(CompanyInfoBankAccNo; CompanyInfo."Bank Account No.")
            {
            }
            column(CompanyInfoPhone; CompanyInfo."Phone No.")
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(DocDate_PurchRcptHeader; Format("Purch. Rcpt. Header"."Document Date", 0, 4))
            {
            }
            column(VendAddr1; VendAddr[1])
            {
            }
            column(VendAddr2; VendAddr[2])
            {
            }
            column(VendAddr3; VendAddr[3])
            {
            }
            column(VendAddr4; VendAddr[4])
            {
            }
            column(VendAddr5; VendAddr[5])
            {
            }
            column(VendAddr6; VendAddr[6])
            {
            }
            column(VendAddr7; VendAddr[7])
            {
            }
            column(VendAddr8; VendAddr[8])
            {
            }
            dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            {
                DataItemLink = "Document No."=FIELD("No.");
                DataItemLinkReference = "Purch. Rcpt. Header";
                DataItemTableView = SORTING("Document No.", "Line No.");

                column(ItemNo; "No.")
                {
                }
                column(Line_No_; "Line No.")
                {
                }
                column(Description; Description)
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(Unit_of_Measure_Code; "Unit of Measure Code")
                {
                }
                column(LotNo; LotNo)
                {
                }
                column(DoNotShow; DoNotShow)
                {
                }
                dataitem("Item Ledger Entry"; "Item Ledger Entry")
                {
                    DataItemLink = "Document No."=FIELD("Document No."), "Item No."=field("No."), "Document Line No."=field("Line No.");

                    ;
                    DataItemLinkReference = "Purch. Rcpt. Line";

                    column(Document_No_; "Document No.")
                    {
                    }
                    column(LotNo_ILE; "Item Ledger Entry"."Lot No.")
                    {
                    }
                    column(Lot_Qty; Quantity)
                    {
                    }
                    trigger OnPreDataItem()
                    var
                    begin
                    end;
                }
                trigger OnAfterGetRecord()
                begin
                    Clear(LotNo);
                    recILE.RESET;
                    recILE.SETRANGE(recILE."Document No.", "Purch. Rcpt. Line"."Document No.");
                    recILE.SETRANGE(recILE."Item No.", "Purch. Rcpt. Line"."No.");
                    if recILE.FindFirst()then begin
                        DoNotShow:=false;
                        repeat if LotNo = '' then LotNo:=recILE."Lot No."
                            else
                                LotNo:=LotNo + ',' + recILE."Lot No.";
                        until recILE.Next() = 0;
                    end
                    else
                        DoNotShow:=true;
                end;
                trigger OnPreDataItem()
                begin
                    SetFilter(Quantity, '>%1', 0);
                end;
            }
            trigger OnAfterGetRecord()
            begin
                if SalesPurchPerson.Get("Purch. Rcpt. Header"."Purchaser Code")then;
                FormatAddressFields("Purch. Rcpt. Header");
                if UserRec.Get("Purch. Rcpt. Header".SystemCreatedBy)then;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
    }
    trigger OnInitReport()
    begin
        CompanyInfo.SetAutoCalcFields(Picture);
        CompanyInfo.Get();
    end;
    local procedure FormatAddressFields(var PurchRcptHeader: Record "Purch. Rcpt. Header")
    begin
        FormatAddr.GetCompanyAddr(PurchRcptHeader."Responsibility Center", RespCenter, CompanyInfo, CompanyAddr);
        FormatAddr.PurchRcptShipTo(ShipToAddr, PurchRcptHeader);
        FormatAddr.PurchRcptPayTo(VendAddr, PurchRcptHeader);
    end;
    var FormatAddr: Codeunit "Format Address";
    VendAddr: array[8]of Text[100];
    ShipToAddr: array[8]of Text[100];
    CompanyAddr: array[8]of Text[100];
    RespCenter: Record "Responsibility Center";
    CompanyInfo: Record "Company Information";
    SalesPurchPerson: Record "Salesperson/Purchaser";
    LotNo: Code[350];
    recILE: Record "Item Ledger Entry";
    DoNotShow: Boolean;
    UserRec: Record User;
}
