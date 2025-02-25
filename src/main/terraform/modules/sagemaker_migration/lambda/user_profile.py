class ODDWUserProfile:
    def __init__(self, user_profile_name):
        self.user_profile_name = user_profile_name
        self.spaces = []

    def __save_user_data(self):
        for space in self.spaces:
            space.backup_ebs_volumes()

    def recreate_in_target_domain(self, target_domain_id):
        self.__save_user_data()
        sagemaker_client.create_user_profile(DomainId=target_domain_id, UserProfileName=self.user_profile_name)
        for space in self.spaces:
            space.recreate_in_target_domain(target_domain_id, self.user_profile_name)
