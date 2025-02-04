# Academic Conference Landing Page with Call for Proposals Funcationality
This typeswift + vite project has a basic landing page with a Supabase supported backend to store the submissions. I elected to have the bucket not-viewable to the public, but only to a select `admin_user` role. This was specific to my use case, but policies could be modified. 

I used Bolt to orchestrate most of the packages and deployment. I did this in January 2025, and the interactive LLM feature w/in Bolt worked honestly, fantastic. 
Full deployment details below:

## STOC 2025 TheoryFest Website

> Official website for the 57th Annual ACM Symposium on Theory of Computing (STOC 2025), part of TheoryFest 2025.

### Features

- Workshop proposal submission system
- Admin review interface
- Conference information and schedule
- Responsive design for all devices

### Tech Stack

- React 18 with TypeScript
- Vite for fast development and building
- Tailwind CSS for styling
- Supabase for backend and authentication
- Lucide React for icons

### Getting Started

1. Clone the repository
2. Copy `.env.example` to `.env` and fill in your Supabase credentials
3. Install dependencies:
   ```bash
   npm install
   ```
4. Start the development server:
   ```bash
   npm run dev
   ```

### Environment Variables

Required environment variables in your `.env` file:

```bash
VITE_SUPABASE_URL=your-supabase-project-url
VITE_SUPABASE_ANON_KEY=your-supabase-anon-key
```

⚠️ IMPORTANT: Never commit your `.env` file to version control!

### Development

```bash
# Start development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

### Deployment

This project is configured for deployment on Netlify. The live site is available at: https://stoc2025theoryfest.netlify.app/

To deploy your own instance:

1. Fork this repository
2. Create a new site on Netlify
3. Connect it to your forked repository
4. Set the required environment variables in Netlify's dashboard
5. Deploy!

### Database Setup

The project uses Supabase for data storage and authentication. Required tables:

- `submissions`: Stores workshop proposals
- `admin_users`: Manages admin access

Database migrations are located in the `supabase/migrations` directory.

### Security

- Row Level Security (RLS) is enabled on all tables
- Authentication is required for admin access
- File uploads are restricted to PDFs only
- All API endpoints are protected

### Contributing

1. Create a feature branch
2. Make your changes
3. Submit a pull request

Please ensure your PR:
- Follows the existing code style
- Includes appropriate tests
- Updates documentation as needed

### License

MIT License - see LICENSE file for details