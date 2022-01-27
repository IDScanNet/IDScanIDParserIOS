import XCTest
import IDScanPDFParser
import IDScanMRZParser

final class IDScanIDParserTests: XCTestCase {
    func test() {
        var errors = [String]()
        errors.append(contentsOf: self.testPDF())
        errors.append(contentsOf: self.testMRZ())
        
        self.assertErrors(errors: errors, componentName: "IDScanIDParser")
    }
    
    func testPDF() -> [String] {
        let raw = "@\n\u{1E}\rANSI 6360100102DL00390196ZF02350052DLDAALICENSE,SAMPLE,DRIVER\nDAG2900 APALACHEE PKWY\nDAITALLAHASSEE\nDAJFL\nDAK32399-0565 \nDAQL252784655541\nDARE   \nDAS          \nDAT     \nDBA20120214\nDBB19650214\nDBC2\nDBD20061121\nDBHN         \nDAU507\rZFZFADUPLICATE: 20070504\nZFB \nZFCQ010705040011\nZFD \r"
        
        let parser = IDScanPDFParser()
        
        guard let dict = parser.parse(raw) else {
            return ["PDF PARSING: result is nil"]
        }
        
        var errors: [String] = []
        
        if dict["fullName"] != "LICENSE SAMPLE DRIVER" {
            errors.append("PDF PARSING: wrong fullName '\(dict["fullName"] ?? "nil")'")
        }
        if dict["documentType"] != "DL" {
            errors.append("PDF PARSING: wrong documentType '\(dict["documentType"] ?? "nil")'")
        }
        if dict["jurisdictionCode"] != "FL" {
            errors.append("PDF PARSING: wrong jurisdictionCode '\(dict["jurisdictionCode"] ?? "nil")'")
        }
        if dict["address1"] != "2900 APALACHEE PKWY" {
            errors.append("PDF PARSING: wrong address1 '\(dict["address1"] ?? "nil")'")
        }
        if dict["issueDate"] != "11/21/2006" {
            errors.append("PDF PARSING: wrong issueDate '\(dict["issueDate"] ?? "nil")'")
        }
        if dict["countryCode"] != "USA" {
            errors.append("PDF PARSING: wrong countryCode '\(dict["countryCode"] ?? "nil")'")
        }
        if dict["classificationCode"] != "E" {
            errors.append("PDF PARSING: wrong classificationCode '\(dict["classificationCode"] ?? "nil")'")
        }
        if dict["birthDate"] != "02/14/1965" {
            errors.append("PDF PARSING: wrong birthDate '\(dict["birthDate"] ?? "nil")'")
        }
        if dict["issuedBy"] != "FL" {
            errors.append("PDF PARSING: wrong issuedBy '\(dict["issuedBy"] ?? "nil")'")
        }
        if dict["country"] != "United States" {
            errors.append("PDF PARSING: wrong country '\(dict["country"] ?? "nil")'")
        }
        if dict["licenseNumber"] != "L252784655541" {
            errors.append("PDF PARSING: wrong licenseNumber '\(dict["licenseNumber"] ?? "nil")'")
        }
        if dict["height"] != "5\'07\"" {
            errors.append("PDF PARSING: wrong height '\(dict["height"] ?? "nil")'")
        }
        if dict["city"] != "TALLAHASSEE" {
            errors.append("PDF PARSING: wrong city '\(dict["city"] ?? "nil")'")
        }
        if dict["issuerIdNum"] != "636010" {
            errors.append("PDF PARSING: wrong issuerIdNum '\(dict["issuerIdNum"] ?? "nil")'")
        }
        if dict["IIN"] != "636010" {
            errors.append("PDF PARSING: wrong IIN '\(dict["IIN"] ?? "nil")'")
        }
        if dict["postalCode"] != "32399-0565" {
            errors.append("PDF PARSING: wrong postalCode '\(dict["postalCode"] ?? "nil")'")
        }
        if dict["gender"] != "Female" {
            errors.append("PDF PARSING: wrong gender '\(dict["gender"] ?? "nil")'")
        }
        if dict["expirationDate"] != "02/14/2012" {
            errors.append("PDF PARSING: wrong expirationDate '\(dict["expirationDate"] ?? "nil")'")
        }
        
        return errors
    }
    
    func testMRZ() -> [String] {
        let raw = "P<UTOBANDERAS<<LILIAN<<<<<<<<<<<<<<<<<<<<<<<\n0123456784UTO8001014F2501017<<<<<<<<<<<<<<06\n"
        
        let parser = IDScanMRZParser()
        
        guard let dict = parser.parse(raw) else {
            return ["MRZ PARSING: can't parse"]
        }
        
        var errors: [String] = []
        
        if dict["expirationDate"] != "01/01/2025" {
            errors.append("MRZ PARSING: wrong expirationDate '\(dict["expirationDate"] ?? "nil")'")
        }
        if dict["firstName"] != "LILIAN" {
            errors.append("MRZ PARSING: wrong firstName '\(dict["firstName"] ?? "nil")'")
        }
        if dict["lastName"] != "BANDERAS" {
            errors.append("MRZ PARSING: wrong lastName '\(dict["lastName"] ?? "nil")'")
        }
        if dict["documentType"] != "PASSPORT" {
            errors.append("MRZ PARSING: wrong documentType '\(dict["documentType"] ?? "nil")'")
        }
        if dict["birthDate"] != "01/01/1980" {
            errors.append("MRZ PARSING: wrong birthDate '\(dict["birthDate"] ?? "nil")'")
        }
        if dict["nationality"] != "UTO" {
            errors.append("MRZ PARSING: wrong nationality '\(dict["nationality"] ?? "nil")'")
        }
        if dict["countryCode"] != "UTO" {
            errors.append("MRZ PARSING: wrong countryCode '\(dict["countryCode"] ?? "nil")'")
        }
        if dict["gender"] != "Female" {
            errors.append("MRZ PARSING: wrong gender '\(dict["gender"] ?? "nil")'")
        }
        if dict["licenseNumber"] != "012345678" {
            errors.append("MRZ PARSING: wrong licenseNumber '\(dict["licenseNumber"] ?? "nil")'")
        }
        
        return errors
    }
    
    func formatErrors(_ errors: [String], componentName: String) -> String? {
        if errors.count == 0 {
            return nil
        }
        
        let newLineCorrectedErrors = errors.map { (error) -> String in
            return error.replacingOccurrences(of: "\n", with: "\n    ")
        }
        
        let bottomSeparator = String(repeating: "#", count: 100)
        let topSeparator = "## \(componentName) Errors: " + bottomSeparator.dropLast(componentName.count + 12)
        
        let formattedErrors = "\n\n\n\(topSeparator)\n\n" + " -> " + newLineCorrectedErrors.joined(separator: "\n\n -> ") + "\n\n\(bottomSeparator)\n\n\n"
        
        return formattedErrors
    }
    
    func assertErrors(errors: [String], componentName: String) {
        if let formattedErrors = self.formatErrors(errors, componentName: componentName) {
            XCTFail(formattedErrors)
        }
    }
}
