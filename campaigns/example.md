---
# Campaign pages are normal Jekyll pages on the main branch.
# Copy this file, rename it, and change only the front matter needed for that campaign.
layout: landing

# Title/description/canonical_url control SEO metadata for this campaign page.
title: First-Time Buyer Inspection Landing Page
description: "Placeholder: campaign landing page for first-time homebuyers who want a calmer inspection process."
canonical_url: "/campaigns/example/"

# These hero values override _data/company.yml only for this campaign page.
hero_heading: "A first home purchase is stressful enough without unclear inspection reporting."
hero_subheading: "Placeholder: this campaign page reuses the shared landing layout while tailoring the headline, CTA, and testimonial visibility for first-time buyers."

# CTA overrides must keep both label and href.
# href can point to a section ID on the same page, such as #contact or #process.
primary_cta:
  label: "Book a Buyer Inspection"
  href: "#contact"
secondary_cta:
  label: "Review the Process"
  href: "#process"

# Set this to true or remove it to show testimonials on the campaign page.
show_testimonials: false
---
