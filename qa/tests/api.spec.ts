import { test, expect } from '@playwright/test'


test.describe('smoke tests for program applications list api endpoint', () => {
    const programSlugs = (process.env.PROGRAM_SLUGS || '').split(',')

    for (const programSlug of programSlugs) {
        test(`program slug: ${programSlug}`, async ({ request }) => {
            const response = await request.get(`/api/v1/admin/programs/${programSlug}/applications`, {
                params: {
                    'pageSize': 1
                }
            })

            expect(response).toBeOK()

            const result: ApiResult = await response.json()

            expect(result).not.toBeNull()
            expect(result.payload.length).toBeLessThanOrEqual(1)

            if (result.payload.length > 0) {
                expect(result.payload[0].application).not.toBeNull()
            }
        })
    }
})

interface ApiResult {
    nextPageToken: string | null
    payload: Payload[]
}

interface Payload {
    applicant_id: number
    application_id: number
    create_time: string
    language: string
    program_name: string
    program_version_id: number
    revision_state: string
    status: string | null
    submit_time: string
    submitter_type: string
    ti_email: string | null
    ti_organization: string | null
    application: any
}
