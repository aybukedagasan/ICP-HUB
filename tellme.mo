import Array "mo:base/Array";

type Story = {
    id: Nat;
    author: Text;
    title: Text;
    content: Text;
    votes: Int; // New field to store votes
};

actor StorytellingPlatform {


    var stories: [Story] = [];
    var nextId: Nat = 0;

    public func publishStory(title: Text, content: Text, author: Text) : async Nat {
        let newStory: Story = {
            id = nextId;
            author = author;
            title = title;
            content = content;
            votes = 0; // Initialize votes to 0
        };
        stories := stories # [newStory]; // Append the new story
        nextId := nextId + 1;
        return newStory.id;
    };

    public func getStory(id: Nat) : async ?Story {
        let index = findIndex(stories, id);
        switch index {
            case (?i) { return ?stories[i]; };
            case null { return null; };
        }
    };


    public func getAllStories() : async [Story] {
        return stories;
    };

    public func deleteStory(id: Nat) : async Bool {
        let index = findIndex(stories, id);
        switch index {
            case (?i) {
                stories := removeAt(stories, i);
                return true;
            };
            case null { return false; };
        }
    };
    public func voteStory(id: Nat, vote: Int) : async Bool {
        let index = findIndex(stories, id);
        switch index {
            case (?i) {
                let updatedStory = stories[i];
                updatedStory.votes := updatedStory.votes + vote; // Update the vote count
                stories[i] := updatedStory; // Update the story in the array
                return true;
            };
            case null { return false; };
        }
    };
    private func findIndex(stories: [Story], id: Nat) : ?Nat {
        switch (Array.findIndex(stories, func (story) : Bool {
            story.id == id
        })) {
            case (null) { return null; };
            case (?i) { return ?i; };
        }
    };

    private func removeAt(arr: [Story], index: Nat) : [Story] {
        let len = Array.size(arr);
        if (index >= len) {
            return arr; // Index out of bounds, return the original array
        };
        
        // Create a new array by concatenating the slices
        let before = Array.slice(arr, 0, index);
        let after = Array.slice(arr, index + 1, len);
        return before # after;
    };

    public func testVoteStory() : async Bool {
        let id = await publishStory("Test Title", "Test Content", "Test Author");
        let success = await voteStory(id, 1); // Upvote the story
        return success;
    };
};
