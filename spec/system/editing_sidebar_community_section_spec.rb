# frozen_string_literal: true

RSpec.describe "Editing Sidebar Community Section", type: :system do
  fab!(:admin) { Fabricate(:admin) }
  fab!(:user) { Fabricate(:user) }

  let(:sidebar) { PageObjects::Components::NavigationMenu::Sidebar.new }
  let(:sidebar_header_dropdown) { PageObjects::Components::NavigationMenu::HeaderDropdown.new }

  it "should not display the edit section button to non admins" do
    sign_in(user)

    visit("/latest")

    sidebar.click_community_section_more_button

    expect(sidebar).to have_no_customize_community_section_button
  end

  it "allows admin to edit community section and reset to default" do
    sign_in(admin)

    visit("/latest")

    expect(sidebar.primary_section_icons("community")).to eq(
      %w[layer-group user flag wrench ellipsis-v],
    )

    modal = sidebar.click_community_section_more_button.click_customize_community_section_button
    modal.fill_link("Topics", "/latest", "paper-plane")
    modal.topics_link.drag_to(modal.review_link, delay: 0.4)
    modal.save

    expect(sidebar.primary_section_links("community")).to eq(
      ["My Posts", "Topics", "Review", "Admin", "More"],
    )

    expect(sidebar.primary_section_icons("community")).to eq(
      %w[user paper-plane flag wrench ellipsis-v],
    )

    modal = sidebar.click_community_section_more_button.click_customize_community_section_button
    modal.reset

    expect(sidebar).to have_section("Community")

    expect(sidebar.primary_section_links("community")).to eq(
      ["Topics", "My Posts", "Review", "Admin", "More"],
    )

    expect(sidebar.primary_section_icons("community")).to eq(
      %w[layer-group user flag wrench ellipsis-v],
    )
  end

  it "allows admin to edit community section when no secondary section links" do
    SidebarSection
      .where(title: "Community")
      .first
      .sidebar_section_links
      .where.not(position: 0)
      .destroy_all

    sign_in(admin)

    visit("/latest")

    modal = sidebar.click_customize_community_section_button

    expect(modal).to be_visible
  end

  it "should allow admins to open modal to edit the section when `navigation_menu` site setting is `header dropdown`" do
    SiteSetting.navigation_menu = "header dropdown"

    sign_in(admin)

    visit("/latest")

    modal = sidebar_header_dropdown.open.click_customize_community_section_button

    expect(modal).to be_visible
  end
end
