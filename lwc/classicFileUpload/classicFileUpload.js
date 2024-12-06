import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import uploadFile from '@salesforce/apex/FileUploaderClass.uploadFile';

export default class UploadFiles extends LightningElement {
    @api recordId;
    @track filesData = []; // Reactive files data for upload
    @track isUploading = false; // Track whether files are being uploaded
    MAX_FILE_SIZE = 25 * 1024 * 1024; // 25 MB limit

    openfileUpload(event) {
        const files = event.target.files;
        this.filesData = []; // Reset filesData for new selection

        Array.from(files).forEach(file => {
            // Check if file size exceeds the maximum allowed size
            if (file.size > this.MAX_FILE_SIZE) {
                this.toast(`File ${file.name} exceeds the size limit of 25 MB`, 'error');
                return; // Skip this file if it's too large
            }

            // Handle image files (JPEG, PNG, etc.)
            if (file.type.startsWith('image/')) {
                this.compressImage(file);
            } 
            // Handle video files (MP4, AVI, etc.)
            else if (file.type.startsWith('video/')) {
                let reader = new FileReader();
                reader.onload = () => {
                    let base64 = reader.result.split(',')[1]; // Get base64 data
                    this.filesData.push({
                        filename: file.name,
                        base64: base64,
                        recordId: this.recordId
                    });
                };
                reader.readAsDataURL(file); // Read video file as data URL (base64)
            }
            else {
                // Handle other file types (e.g., PDFs, docs)
                let reader = new FileReader();
                reader.onload = () => {
                    let base64 = reader.result.split(',')[1]; // Get base64 data
                    this.filesData.push({
                        filename: file.name,
                        base64: base64,
                        recordId: this.recordId
                    });
                };
                reader.readAsDataURL(file);
            }
        });
    }

    compressImage(file) {
        const reader = new FileReader();
        reader.onload = () => {
            const img = new Image();
            img.src = reader.result;
            img.onload = () => {
                // Create a canvas to resize the image
                const canvas = document.createElement('canvas');
                const ctx = canvas.getContext('2d');
                // Set canvas dimensions (resize to a max width of 800px)
                const MAX_WIDTH = 800;
                const scale = MAX_WIDTH / img.width;
                canvas.width = MAX_WIDTH;
                canvas.height = img.height * scale;
                // Draw the resized image onto the canvas
                ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
                // Convert the canvas image to base64 with reduced quality
                const base64 = canvas.toDataURL('image/jpeg', 0.8).split(',')[1]; // Adjust quality (0.8 = 80%)
                this.filesData.push({
                    filename: file.name,
                    base64: base64,
                    recordId: this.recordId
                });
            };
        };
        reader.readAsDataURL(file);
    }

    async handleClick() {
        if (this.filesData.length === 0) {
            this.toast('No files selected', 'error');
            return;
        }

        this.isUploading = true; // Start the loading process (show spinner)

        const uploadPromises = this.filesData.map(fileData => {
            const { base64, filename, recordId } = fileData;
            return uploadFile({ base64, filename, recordId })
                .then(() => ({ filename, success: true }))
                .catch(error => {
                    console.error(error);
                    return { filename, success: false };
                });
        });

        try {
            const results = await Promise.all(uploadPromises);
            const successfulUploads = results.filter(result => result.success);
            const failedUploads = results.filter(result => !result.success);

            // Display a single toast summarizing the results
            if (failedUploads.length === 0) {
                this.toast(`${successfulUploads.length} file(s) uploaded successfully!`);
            } else if (successfulUploads.length === 0) {
                this.toast(`Failed to upload ${failedUploads.length} file(s)`, 'error');
            } else {
                this.toast(
                    `${successfulUploads.length} file(s) uploaded successfully, but ${failedUploads.length} failed.`,
                    'warning'
                );
            }

            this.filesData = []; // Clear file data after processing
            this.clearFileInput();
            window.location.reload(); // Refresh the page
        } catch (e) {
            console.error('Unexpected error in uploading files', e);
            this.toast('An unexpected error occurred during upload', 'error');
        } finally {
            this.isUploading = false; // Hide the loading spinner once upload completes
        }
    }

    handleCancel() {
        this.filesData = [];
        this.clearFileInput();
    }

    clearFileInput() {
        const fileInput = this.template.querySelector('input[type="file"]');
        if (fileInput) {
            fileInput.value = null; // Reset the file input
        }
    }

    toast(title, variant = 'success') {
        const toastEvent = new ShowToastEvent({
            title,
            variant
        });
        this.dispatchEvent(toastEvent);
    }
}