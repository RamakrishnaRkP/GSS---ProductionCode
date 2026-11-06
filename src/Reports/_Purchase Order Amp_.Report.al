report 60129 "Purchase Order Amp"
{
    Caption = 'Purchase Order Amp';
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/PurchaseOrder.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.")WHERE("Document Type"=CONST(Order));
            RequestFilterFields = "No.", "Buy-from Vendor No.", "No. Printed";
            RequestFilterHeading = 'Purchase - Order';

            column(No_; "No.")
            {
            }
            column(Document_Date; Format("Document Date"))
            {
            }
            column(Currency_Code; CurrCode)
            {
            }
            column(Pay_to_Address; "Pay-to Address")
            {
            }
            column(Pay_to_Name; "Pay-to Name")
            {
            }
            column(Payment_Terms_Code; "Payment Terms Description")
            {
            }
            column(TotalAmount; TotalAmount)
            {
            }
            column(AmtInWords; Notext[1] + ' ' + NoText[2])
            {
            }
            column(VendorEmail; VendorRec."E-Mail")
            {
            }
            column(VendorFax; VendorRec."Fax No.")
            {
            }
            column(Pay_to_Contact_No_; PayToContact."Phone No.")
            {
            }
            column(CompInfo_Picture; CompInfo.Picture)
            {
            }
            column(CompanyInfoHomepage; CompInfo."Home Page")
            {
            }
            column(CompAddress; CompInfo.Address + ' Phone No. : ' + CompInfo."Phone No.")
            {
            }
            column(CompTRN; CompInfo."VAT Registration No.")
            {
            }
            column(VendorTRN; VendorRec."VAT Registration No.")
            {
            }
            column(Vendor_Order_No_; "Your Reference")
            {
            }
            column(SalesPurchPersonName; SalesPurchPerson.Name)
            {
            }
            column(Attention; "Transport Method")
            {
            }
            column(DeliveryDate; Format("Requested Receipt Date"))
            {
            }
            column(ShiptoAddress; "Purchase Header"."Ship-to Address" + ' ' + "Purchase Header"."Ship-to Address 2")
            {
            }
            column(ShiptoName; "Ship-to Name")
            {
            }
            column(ShiptoCity; "Ship-to City")
            {
            }
            column(ShowPreview; ShowPreview)
            {
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document Type"=FIELD("Document Type"), "Document No."=FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");

                column(ItemNo; ItemNo)
                {
                }
                column(Description; Description)
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(Unit_Price__LCY_; "Direct Unit Cost")
                {
                }
                column(Amount; Amount)
                {
                }
                column(Amount_Including_VAT; "Amount Including VAT")
                {
                }
                column(VAT__; "VAT %")
                {
                }
                column(VAT_Base_Amount; "VAT Base Amount")
                {
                }
                column(Unit_of_Measure_Code; "Unit of Measure Code")
                {
                }
                trigger OnAfterGetRecord()
                var
                begin
                    // TotalAmount += "Purchase Line".Amount;
                    ItemRec.Reset();
                    if ItemRec.Get("Purchase Line"."No.")then ItemNo:=ItemRec."No."
                    else
                        ItemNo:="Purchase Line"."No.";
                end;
            }
            trigger OnAfterGetRecord()
            var
                PurLineRec: Record "Purchase Line";
            begin
                if(("Purchase Header".Status = "Purchase Header".Status::Released) or ("Purchase Header".Status = "Purchase Header".Status::"Completely Invoiced"))then ShowPreview:=false
                else
                    ShowPreview:=true;
                "Purchase Header".CalcFields("Payment Terms Description");
                PayToContact.Reset();
                if "Purchase Header"."Pay-to Contact No." <> '' then if PayToContact.Get("Purchase Header"."Pay-to Contact No.")then;
                if GLSetup.Get()then begin
                    if "Purchase Header"."Currency Code" = '' then CurrCode:=GLSetup."LCY Code"
                    else
                        CurrCode:="Purchase Header"."Currency Code";
                end;
                CompInfo.SetAutoCalcFields(Picture);
                CompInfo.Get;
                Clear(TotalAmount);
                Clear(NoText);
                IF RecContact.GET("Purchase Header"."Buy-from Contact No.")THEN;
                if VendorRec.Get("Pay-to Vendor No.")then;
                if SalesPurchPerson.Get("Purchase Header"."Purchaser Code")then;
                PurLineRec.SetRange("Document Type", "Purchase Header"."Document Type");
                PurLineRec.SetRange("Document No.", "Purchase Header"."No.");
                if PurLineRec.FindSet()then repeat TotalAmount+=PurLineRec."Amount Including VAT";
                    until PurLineRec.Next() = 0;
                ChecRep.InitTextVariable();
                ChecRep.FormatNoText(NoText, Round(TotalAmount), "Purchase Header"."Currency Code");
                if VendorRec.Get("Purchase Header"."Pay-to Vendor No.")then;
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
    var TotalAmount: Decimal;
    ChecRep: Report Check;
    VendorRec: Record Vendor;
    CompInfo: Record "Company Information";
    NoText: array[2]of Text[80];
    SalesPurchPerson: Record "Salesperson/Purchaser";
    RecContact: Record Contact;
    ShowPreview: Boolean;
    PayToContact: Record Contact;
    GLSetup: Record "General Ledger Setup";
    CurrCode: code[20];
    ItemRec: Record Item;
    ItemNo: Code[20];
}
