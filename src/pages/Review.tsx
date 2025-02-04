import React, { useEffect, useState } from 'react';
import { supabase } from '../lib/supabase';
import { FileText, Check, X } from 'lucide-react';
import AdminLogin from '../components/AdminLogin';

interface Submission {
  id: string;
  title: string;
  author_name: string;
  author_email: string;
  affiliation: string;
  pdf_url: string;
  status: string;
  reviewer_notes: string;
  created_at: string;
}

const Review = () => {
  const [submissions, setSubmissions] = useState<Submission[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [selectedSubmission, setSelectedSubmission] = useState<Submission | null>(null);
  const [reviewNotes, setReviewNotes] = useState('');
  const [isAdmin, setIsAdmin] = useState(false);
  const [isCheckingAdmin, setIsCheckingAdmin] = useState(true);

  useEffect(() => {
    checkAdminStatus();
  }, []);

  useEffect(() => {
    if (isAdmin) {
      fetchSubmissions();
    }
  }, [isAdmin]);

  const checkAdminStatus = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      
      if (!user) {
        setIsAdmin(false);
        setIsCheckingAdmin(false);
        return;
      }

      const { data: adminData } = await supabase
        .from('admin_users')
        .select('id')
        .single();

      setIsAdmin(!!adminData);
    } catch (err) {
      console.error('Error checking admin status:', err);
      setIsAdmin(false);
    } finally {
      setIsCheckingAdmin(false);
    }
  };

  const fetchSubmissions = async () => {
    try {
      setLoading(true);
      const { data, error: fetchError } = await supabase
        .from('submissions')
        .select('*')
        .order('created_at', { ascending: false });

      if (fetchError) throw fetchError;

      setSubmissions(data || []);
      setError(null);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to fetch submissions');
      setSubmissions([]);
    } finally {
      setLoading(false);
    }
  };

  const updateSubmissionStatus = async (
    submissionId: string,
    status: 'accepted' | 'rejected'
  ) => {
    try {
      const { error: updateError } = await supabase
        .from('submissions')
        .update({ status, reviewer_notes: reviewNotes })
        .eq('id', submissionId);

      if (updateError) throw updateError;

      setSubmissions((prev) =>
        prev.map((sub) =>
          sub.id === submissionId
            ? { ...sub, status, reviewer_notes: reviewNotes }
            : sub
        )
      );
      setSelectedSubmission(null);
      setReviewNotes('');
      
      await fetchSubmissions();
    } catch (err) {
      setError(
        err instanceof Error ? err.message : 'Failed to update submission status'
      );
    }
  };

  const handleLogin = () => {
    checkAdminStatus();
  };

  if (isCheckingAdmin) {
    return (
      <div className="flex justify-center items-center min-h-[50vh]">
        <div className="text-xl text-gray-600">Checking authentication...</div>
      </div>
    );
  }

  if (!isAdmin) {
    return <AdminLogin onLogin={handleLogin} />;
  }

  if (loading) {
    return (
      <div className="flex justify-center items-center min-h-[50vh]">
        <div className="text-xl text-gray-600">Loading submissions...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative">
        <strong className="font-bold">Error: </strong>
        <span className="block sm:inline">{error}</span>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div className="flex items-center space-x-3">
          <FileText className="h-8 w-8 text-blue-600" />
          <h1 className="text-2xl font-bold">Review Submissions</h1>
        </div>
        <button
          onClick={fetchSubmissions}
          className="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition"
        >
          Refresh
        </button>
      </div>

      <div className="grid md:grid-cols-2 gap-6">
        {/* Submissions List */}
        <div className="space-y-4">
          {submissions.length === 0 ? (
            <div className="bg-white p-6 rounded-lg shadow-md text-center text-gray-500">
              No submissions yet
            </div>
          ) : (
            submissions.map((submission) => (
              <div
                key={submission.id}
                className="bg-white p-6 rounded-lg shadow-md cursor-pointer hover:shadow-lg transition"
                onClick={() => setSelectedSubmission(submission)}
              >
                <h3 className="font-semibold text-lg mb-2">{submission.title}</h3>
                <div className="text-sm text-gray-600 space-y-1">
                  <p>Author: {submission.author_name}</p>
                  <p>Affiliation: {submission.affiliation}</p>
                  <p>
                    Status:{' '}
                    <span
                      className={`inline-block px-2 py-1 rounded-full text-xs ${
                        submission.status === 'accepted'
                          ? 'bg-green-100 text-green-700'
                          : submission.status === 'rejected'
                          ? 'bg-red-100 text-red-700'
                          : 'bg-yellow-100 text-yellow-700'
                      }`}
                    >
                      {submission.status || 'pending'}
                    </span>
                  </p>
                </div>
              </div>
            ))
          )}
        </div>

        {/* Review Panel */}
        {selectedSubmission && (
          <div className="bg-white p-6 rounded-lg shadow-md">
            <h2 className="text-xl font-semibold mb-4">Review Submission</h2>
            <div className="space-y-4">
              <div>
                <h3 className="font-medium">Title</h3>
                <p>{selectedSubmission.title}</p>
              </div>
              <div>
                <h3 className="font-medium">Author Information</h3>
                <p>Name: {selectedSubmission.author_name}</p>
                <p>Email: {selectedSubmission.author_email}</p>
                <p>Affiliation: {selectedSubmission.affiliation}</p>
              </div>
              <div>
                <h3 className="font-medium">Paper</h3>
                <a
                  href={selectedSubmission.pdf_url}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-blue-600 hover:underline"
                >
                  View PDF
                </a>
              </div>
              <div>
                <h3 className="font-medium">Review Notes</h3>
                <textarea
                  value={reviewNotes}
                  onChange={(e) => setReviewNotes(e.target.value)}
                  className="w-full h-32 p-2 border rounded-md"
                  placeholder="Enter your review notes..."
                />
              </div>
              <div className="flex space-x-4">
                <button
                  onClick={() =>
                    updateSubmissionStatus(selectedSubmission.id, 'accepted')
                  }
                  className="flex-1 bg-green-600 text-white py-2 px-4 rounded-md hover:bg-green-700 transition flex items-center justify-center space-x-2"
                >
                  <Check className="h-5 w-5" />
                  <span>Accept</span>
                </button>
                <button
                  onClick={() =>
                    updateSubmissionStatus(selectedSubmission.id, 'rejected')
                  }
                  className="flex-1 bg-red-600 text-white py-2 px-4 rounded-md hover:bg-red-700 transition flex items-center justify-center space-x-2"
                >
                  <X className="h-5 w-5" />
                  <span>Reject</span>
                </button>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default Review;