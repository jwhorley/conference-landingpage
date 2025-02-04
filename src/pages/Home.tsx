import React from 'react';
import { Calendar, MapPin, Users } from 'lucide-react';
import { Link } from 'react-router-dom';

const Home = () => {
  return (
    <div className="space-y-12">
      {/* Hero Section with Banner */}
      <section className="relative -mt-24 mb-16">
        <div className="absolute inset-0">
          <img
            src="https://images.unsplash.com/photo-1633722002939-85d9b2a4c1d9?auto=format&fit=crop&q=80&w=2070"
            alt="Conference hall"
            className="w-full h-[500px] object-cover"
          />
          <div className="absolute inset-0 bg-gradient-to-r from-blue-900/80 to-blue-900/65"></div>
        </div>
        
        <div className="relative pt-32 pb-20 px-4">
          <div className="max-w-4xl mx-auto text-center text-white space-y-6">
            <h1 className="text-4xl md:text-5xl font-bold">
              STOC 2025<br />
              57th Annual ACM Symposium on Theory of Computing
            </h1>
            <p className="text-xl text-gray-200">
              TheoryFest 2025 Call for Workshops<br />
              June 23-27, 2025 in Prague, Czech Republic
            </p>
            <div className="flex justify-center space-x-4">
              <Link
                to="/submit"
                className="bg-blue-600 text-white px-8 py-3 rounded-lg hover:bg-blue-700 transition shadow-lg"
              >
                Submit Proposal
              </Link>
            </div>
          </div>
        </div>
      </section>

      {/* Key Information */}
      <section className="grid md:grid-cols-3 gap-8">
        <div className="bg-white p-6 rounded-lg shadow-md text-center">
          <Calendar className="w-12 h-12 mx-auto text-blue-600 mb-4" />
          <h3 className="text-xl font-semibold mb-2">Date</h3>
          <p>June 23-27, 2025</p>
        </div>
        <div className="bg-white p-6 rounded-lg shadow-md text-center">
          <MapPin className="w-12 h-12 mx-auto text-blue-600 mb-4" />
          <h3 className="text-xl font-semibold mb-2">Location</h3>
          <p>Prague<br />Czech Republic</p>
        </div>
        <div className="bg-white p-6 rounded-lg shadow-md text-center">
          <Users className="w-12 h-12 mx-auto text-blue-600 mb-4" />
          <h3 className="text-xl font-semibold mb-2">Participants</h3>
          <p>Leading Researchers in Theoretical Computer Science</p>
        </div>
      </section>

      {/* Important Dates */}
      <section className="bg-white p-8 rounded-lg shadow-md">
        <h2 className="text-2xl font-bold mb-6">Important Dates</h2>
        <div className="space-y-4">
          <div className="flex justify-between items-center border-b pb-4">
            <span className="font-semibold">Submission deadline</span>
            <span>Mar 2, 2025</span>
          </div>
          <div className="flex justify-between items-center border-b pb-4">
            <span className="font-semibold">Notification</span>
            <span>March 16, 2025</span>
          </div>
          <div className="flex justify-between items-center">
            <span className="font-semibold">Workshops held during TheoryFest</span>
            <span>June 23–27, 2025</span>
          </div>
        </div>
      </section>

      {/* About Section */}
      <section className="bg-white p-8 rounded-lg shadow-md">
        <h2 className="text-2xl font-bold mb-4">TheoryFest 2025 will hold workshops during the conference week, June 23–27, 2025. We invite groups of interested researchers to submit workshop proposals.</h2>
        <p className="text-gray-600 leading-relaxed">
          The TheoryFest workshops will provide an informal forum for researchers to discuss important research questions, directions and challenges in the field, as well as a venue to invite new researchers to an area. They will begin with a tutorial, and will continue with research talks or other events highlighting recent results and new directions. We encourage workshops that focus on connections between theoretical computer science and other areas.
        </p>
      </section>

      {/* Proposal Submission Section */}
      <section className="bg-white p-8 rounded-lg shadow-md">
        <h2 className="text-2xl font-bold mb-4">Proposal Submission</h2>
        <p className="text-gray-600 leading-relaxed">
          Workshop and tutorial proposals should, ideally, fit within two pages. Please include a list of names and email addresses of the organizers, a brief description of the topic and the goals of the workshop, and the format (what mix of tutorial, invited talks or other events) and proposed or tentatively confirmed speakers if known. Feel free to contact the Workshops Committee (listed below) directly with questions.
        </p>
        <p className="text-gray-500 leading-relaxed">
          W.T. Door | email@email.edu
        </p>
      </section>
    </div>
  );
};

export default Home;