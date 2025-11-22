// Licensed under the P-EADCA Universal Waiver License (PUWL v2.0draft02)
// See LICENSE.puwl in the project root for details.

// https://docs.renovatebot.com/configuration-options/

module.exports = {
    onboarding: true,
    onboardingConfigFileName: 'renovate.json5',
    platform: 'github',
    repositories: ['balihb/SpringBoot_CRUD_Postgre_Tutorial'],
    repositoryCache: 'enabled',
    hostRules: [
        {
            matchHost: 'pypi.org',
            enableHttp2: true,
        },
    ],
    exposeAllEnv: true,
    customEnvVariables: {
        FORCE_COLOR: '0',
    },
}
