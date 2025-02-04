import React, { useState } from 'react';
import { FileText } from 'lucide-react';
import { supabase } from '../lib/supabase';

const Submit = () => {
  const [formData, setFormData] = useState({
    title: '',
    authorName: '',
    email: '',
    affiliation: '',
    file: null as File | null,
  });
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitStatus, setSubmitStatus] = useState<{
    type: 'success' | 'error';
    message: string;
  } | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);
    setSubmitStatus(null);

    try {
      if (!formData.file) {
        throw new Error('Please select a PDF file');
      }

      // Upload PDF to Supabase Storage
      const fileExt = formData.file.name.split('.').pop();
      const fileName = `${Math.random().toString(36).substring(2)}.${fileExt}`;
      
      const { data: uploadData, error: uploadError } = await supabase.storage
        .from('paper-submissions')
        .upload(fileName, formData.file);

      if (uploadError) throw uploadError;

      // Get the public URL for the uploaded file
      const { data: { publicUrl } } = supabase.storage
        .from('paper-submissions')
        .getPublicUrl(fileName);

      // Create submission record
      const { error: submissionError } = await supabase
        .from('submissions')
        .insert([
          {
            title: formData.title,
            author_name: formData.authorName,
            author_email: formData.email,
            affiliation: formData.affiliation,
            pdf_url: publicUrl,
          },
        ]);

      if (submissionError) throw submissionError;

      setSubmitStatus({
        type: 'success',
        message: 'Your paper has been successfully submitted!',
      });
      
      // Reset form
      setFormData({
        title: '',
        authorName: '',
        email: '',
        affiliation: '',
        file: null,
      });
      
    } catch (error) {
      setSubmitStatus({
        type: 'error',
        message: error instanceof Error ? error.message : 'An error occurred during submission',
      });
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="max-w-2xl mx-auto">
      <div className="bg-white p-8 rounded-lg shadow-md">
        <div className="flex items-center space-x-3 mb-6">
          <FileText className="h-8 w-8 text-blue-600" />
          <h1 className="text-2xl font-bold">Submit Your Paper</h1>
        </div>

        {submitStatus && (
          <div
            className={`p-4 mb-6 rounded-lg ${
              submitStatus.type === 'success'
                ? 'bg-green-100 text-green-700'
                : 'bg-red-100 text-red-700'
            }`}
          >
            {submitStatus.message}
          </div>
        )}

        <form onSubmit={handleSubmit} className="space-y-6">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Paper Title
            </label>
            <input
              type="text"
              required
              value={formData.title}
              onChange={(e) =>
                setFormData((prev) => ({ ...prev, title: e.target.value }))
              }
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Author Name
            </label>
            <input
              type="text"
              required
              value={formData.authorName}
              onChange={(e) =>
                setFormData((prev) => ({ ...prev, authorName: e.target.value }))
              }
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Email
            </label>
            <input
              type="email"
              required
              value={formData.email}
              onChange={(e) =>
                setFormData((prev) => ({ ...prev, email: e.target.value }))
              }
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Affiliation
            </label>
            <input
              type="text"
              required
              value={formData.affiliation}
              onChange={(e) =>
                setFormData((prev) => ({ ...prev, affiliation: e.target.value }))
              }
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              PDF File (2 pages max)
            </label>
            <input
              type="file"
              accept=".pdf"
              required
              onChange={(e) =>
                setFormData((prev) => ({
                  ...prev,
                  file: e.target.files ? e.target.files[0] : null,
                }))
              }
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          <button
            type="submit"
            disabled={isSubmitting}
            className={`w-full bg-blue-600 text-white py-2 px-4 rounded-md hover:bg-blue-700 transition ${
              isSubmitting ? 'opacity-50 cursor-not-allowed' : ''
            }`}
          >
            {isSubmitting ? 'Submitting...' : 'Submit Paper'}
          </button>
        </form>
      </div>
    </div>
  );
};

export default Submit;