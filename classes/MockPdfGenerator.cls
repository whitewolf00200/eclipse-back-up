public class MockPdfGenerator implements IPdfGenerator {
    public Blob generatePDF(PageReference pageReference) {
        // Return mock Blob data to simulate a PDF file.
        return Blob.valueOf('Mock PDF Content');
    }
}